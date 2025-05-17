import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';
import '../api/api_service.dart';
import '../chatbot/constants.dart';
import '../chatbot_models/message.dart';
import '../hive/chat_history.dart';
import '../hive/settings.dart';
import '../hive/user_model.dart';

class ChatProvider extends ChangeNotifier {
  // Private fields
  final List<Message> _inChatMessages = [];
  final PageController _pageController = PageController();
  List<XFile>? _imagesFileList = [];
  int _currentIndex = 0;
  String _currentChatId = '';
  GenerativeModel? _model;
  String _modelType = 'gemini-1.5-pro';
  bool _isLoading = false;
  bool _isResponseInProgress = false;

  // Public getters
  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;

  static bool _hiveInitialized = false;

  // Initialize Hive boxes and adapters
  static Future<void> initHive() async {
    if (_hiveInitialized) return;

    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final dir = await path.getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      await Hive.initFlutter();
    }

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(Constants.settingsBox);
    }

    _hiveInitialized = true;
  }

  // Load messages from DB for a given chatId
  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    try {
      await Hive.openBox('${Constants.chatMessagesBox}$chatId');
      final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');

      return messageBox.keys.map((key) {
        final messageMap = messageBox.get(key);
        return Message.fromMap(Map<String, dynamic>.from(messageMap));
      }).toList();
    } catch (e) {
      log("Error loading messages from DB: $e");
      return [];
    }
  }

  // Set the in-chat messages for a given chat ID
  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
    _inChatMessages
      ..clear()
      ..addAll(messagesFromDB);
    notifyListeners();
  }

  // Save a message to the DB
  Future<void> saveMessageToDB(Message message) async {
    try {
      final messageId = const Uuid().v4();
      message.messageId = messageId;

      await Hive.openBox('${Constants.chatMessagesBox}${message.chatId}');
      final messageBox = Hive.box('${Constants.chatMessagesBox}${message.chatId}');
      await messageBox.put(messageId, message.toMap());

      if (message.role == Role.user) {
        await saveChatHistoryEntry(message);
      }
    } catch (e) {
      log("Error saving message to DB: $e");
    }
  }

  // Save a chat history entry when a user message is sent
  Future<void> saveChatHistoryEntry(Message message) async {
    try {
      final historyBox = Hive.box<ChatHistory>(Constants.chatHistoryBox);
      if (!historyBox.containsKey(message.chatId)) {
        final truncatedMessage = message.message.length > 50
            ? "${message.message.substring(0, 47)}..."
            : message.message;

        final chatHistory = ChatHistory(
          chatId: message.chatId,
          prompt: truncatedMessage,
          response: "",
          timestamp: message.timeSent,
          imagesUrls: message.imagesUrls,
        );

        await historyBox.put(message.chatId, chatHistory);
      }
    } catch (e) {
      log("Error saving chat history entry: $e");
    }
  }

  // Update the images file list
  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  // Set current AI model type
  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  // Initialize the model based on text-only flag
  Future<void> setModel({required bool isTextOnly}) async {
    if (ApiService.apiKey.isEmpty) {
      log("API key is empty!");
      return;
    }
    // You might want to support different models for image/text
    final modelName = 'gemini-1.5-pro'; // same for both in original
    _model = GenerativeModel(
      model: modelName,
      apiKey: ApiService.apiKey,
    );
    notifyListeners();
  }

  // Update the current index of chat or UI pages
  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  // Update current chat ID
  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  // Set loading state
  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear all in-chat messages
  void clearMessages() {
    _inChatMessages.clear();
    notifyListeners();
  }

  // Main method to send user message and process response
  Future<void> sendMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    if (_isResponseInProgress) {
      log("Response in progress, ignoring new message");
      return;
    }

    await setModel(isTextOnly: isTextOnly);
    if (_model == null) {
      log("Model is null. Aborting.");
      return;
    }
    setLoading(value: true);

    final chatId = _getOrCreateChatId();

    final history = await _getHistory(chatId: chatId);
    final imagesUrls = _getImagesUrls(isTextOnly: isTextOnly);

    final userMessage = Message(
      messageId: '',
      chatId: chatId,
      role: Role.user,
      message: message,
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );
    _inChatMessages.add(userMessage);
    notifyListeners();

    await saveMessageToDB(userMessage);

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    _isResponseInProgress = true;
    await _sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
    );
  }

  // Helper to handle sending message to model and waiting for response
  Future<void> _sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
  }) async {
    try {
      final chatSession = _model!.startChat(history: (history.isEmpty || !isTextOnly) ? [] : history);

      final content = await _getContent(message: message, isTextOnly: isTextOnly);
      if (content.isEmpty) {
        setLoading(value: false);
        _isResponseInProgress = false;
        return;
      }

      final assistantMessage = Message(
        messageId: '',
        chatId: chatId,
        role: Role.assistant,
        message: '',
        imagesUrls: [],
        timeSent: DateTime.now(),
      );
      _inChatMessages.add(assistantMessage);
      notifyListeners();

      final response = await chatSession.sendMessage(content.first);
      final responseText = response.text ?? "No valid response received.";

      assistantMessage.message = responseText;
      notifyListeners();

      await saveMessageToDB(assistantMessage);
    } catch (e) {
      final errorMessage = e.toString();
      final assistantErrorMessage = Message(
        messageId: '',
        chatId: chatId,
        role: Role.assistant,
        message: "Error: $errorMessage",
        imagesUrls: [],
        timeSent: DateTime.now(),
      );
      _inChatMessages.add(assistantErrorMessage);
      notifyListeners();
      await saveMessageToDB(assistantErrorMessage);
    } finally {
      setLoading(value: false);
      _isResponseInProgress = false;
      clearImages();
    }
  }

  // Prepare the content payload for the message, including images if any
  Future<List<Content>> _getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return [Content.text(message)];
    }

    final contents = <Content>[Content.text(message)];

    if (_imagesFileList != null && _imagesFileList!.isNotEmpty) {
      for (final image in _imagesFileList!) {
        final bytes = await image.readAsBytes();
        contents.add(Content.data('image/jpeg', bytes));
      }
    }

    return contents;
  }

  // Retrieve chat history as a list of Content
  Future<List<Content>> _getHistory({required String chatId}) async {
    final historyMessages = await loadMessagesFromDB(chatId: chatId);
    final contentList = <Content>[];

    for (final message in historyMessages) {
      if (message.role == Role.user) {
        contentList.add(Content.text(message.message));
      } else if (message.role == Role.assistant) {
        contentList.add(Content.model([TextPart(message.message)]));
      }
    }
    return contentList;
  }

  // Get URLs of images if any and only if not text only
  List<String> _getImagesUrls({required bool isTextOnly}) {
    if (_imagesFileList == null || _imagesFileList!.isEmpty || isTextOnly) {
      return [];
    }
    return _imagesFileList!.map((img) => img.path).toList();
  }

  // Clear selected images
  void clearImages() {
    _imagesFileList = [];
    notifyListeners();
  }

  // Get current chat ID or create a new one if empty
  String _getOrCreateChatId() {
    if (_currentChatId.isNotEmpty) {
      return _currentChatId;
    }
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    setCurrentChatId(newChatId: newId);
    return newId;
  }
}
