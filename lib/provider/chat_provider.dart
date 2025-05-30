import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:generative_ai_dart/generative_ai_dart.dart';
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
  final List<Message> _inChatMessages = [];
  final PageController _pageController = PageController();
  List<XFile>? _imagesFileList = [];
  int _currentIndex = 0;
  String _currentChatId = '';
  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;
  String _modelType = 'gemini-pro';
  bool _isLoading = false;

  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;

  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
    for (var message in messagesFromDB) {
      if (_inChatMessages.contains(message)) continue;
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');
    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      return Message.fromMap(Map<String, dynamic>.from(message));
    }).toList();
    notifyListeners();
    return newData;
  }

  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  Future<void> setModel({required bool isTextOnly}) async {
    if (ApiService.apiKey.isEmpty) {
      log("❌ API key is empty!");
      return;
    }
    final modelName = isTextOnly ? 'gemini-pro' : 'gemini-pro-vision';
    log("✅ Setting model: $modelName");
    if (isTextOnly) {
      _textModel ??= GenerativeModel(
        apiKey: ApiService.apiKey,
        params: ModelParams(model: modelName),
      );
      _model = _textModel;
    } else {
      _visionModel ??= GenerativeModel(
        apiKey: ApiService.apiKey,
        params: ModelParams(model: modelName),
      );
      _model = _visionModel;
    }
    notifyListeners();
  }

  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    log("➡️ sentMessage() called with: $message");
    await setModel(isTextOnly: isTextOnly);
    if (_model == null) {
      log("❌ Model is null. Aborting.");
      return;
    }
    log("✅ Model is set: $_modelType");
    setLoading(value: true);
    String chatId = getChatId();
    List<Content> history = await getHistory(chatId: chatId);
    List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

    final userMessage = Message(
      messageId: '',
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );
    _inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    log("📤 Sending to Gemini...");
    await sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
    );
  }

  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
  }) async {
    log("🧠 Starting Gemini chat session...");
    final chatSession = _model!.startChat(
      (history.isEmpty || !isTextOnly) ? [] : history,
    );

    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    if (content.parts.isEmpty) {
      log("❌ No content parts to send.");
      setLoading(value: false);
      return;
    }

    log("📨 Sending message parts: ${content.parts}");

    final assistantMessage = Message(
      messageId: '',
      chatId: chatId,
      role: Role.assistant,
      message: StringBuffer(),
      imagesUrls: [],
      timeSent: DateTime.now(),
    );
    _inChatMessages.add(assistantMessage);
    notifyListeners();

    bool isResponseComplete = false;  // Track if the response is completed

    chatSession.sendMessageStream(content.parts).listen(
          (event) {
        if (!isResponseComplete) {
          log("📩 Gemini response chunk: ${event.text}");
          assistantMessage.message.write(event.text);
          notifyListeners();
        }
      },
      onDone: () async {
        if (!isResponseComplete) {
          log("✅ Gemini finished responding.");
          isResponseComplete = true;
          setLoading(value: false);
          // await saveMessageToDB(assistantMessage);
        }
      },
      onError: (error, stackTrace) {
        if (!isResponseComplete) {
          log("❌ Gemini error: $error");
          isResponseComplete = true;
          setLoading(value: false);
        }
      },
    );
  }

  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.user([Part.text(message)]);
    } else {
      if (_imagesFileList == null || _imagesFileList!.isEmpty) {
        log("❌ No images selected for vision model.");
        return Content.user([Part.text("No image provided.")]);
      }
      final imageFutures =
      _imagesFileList?.map((imageFile) => imageFile.readAsBytes()).toList(growable: false);
      final imageBytes = await Future.wait(imageFutures!);
      final prompt = Part.text(message);
      final imageParts = imageBytes.map((bytes) => Part.blob(bytes)).toList();
      return Content.user([prompt, ...imageParts]);
    }
  }

  List<String> getImagesUrls({required bool isTextOnly}) {
    List<String> imagesUrls = [];
    if (!isTextOnly && imagesFileList != null) {
      for (var image in imagesFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (currentChatId.isNotEmpty) {
      await setInChatMessages(chatId: chatId);
      for (var message in inChatMessages) {
        final part = Part.text(message.message.toString());
        history.add(
          message.role == Role.user ? Content.user([part]) : Content.model([part]),
        );
      }
    }
    return history;
  }

  String getChatId() {
    return currentChatId.isEmpty ? const Uuid().v4() : currentChatId;
  }

  static Future<void> initHive() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final dir = await path.getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      await Hive.initFlutter(Constants.geminiDB);
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
  }
}
