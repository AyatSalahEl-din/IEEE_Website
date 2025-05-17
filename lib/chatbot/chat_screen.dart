import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import 'chat_history_screen.dart';
import '../chatbot_widgets/bottom_chat_field.dart';
import '../chatbot_widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setCurrentChatId(newChatId: widget.chatId);
    await chatProvider.setInChatMessages(chatId: widget.chatId);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.sendMessage( // ✅ تم التعديل هنا
      message: text,
      isTextOnly: chatProvider.imagesFileList?.isEmpty ?? true,
    );

    chatProvider.clearImages(); // Clear selected images after sending
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    try {
      final images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.setImagesFileList(listValue: images);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Widget _buildSelectedImages(List<XFile> images) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(5),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder: (context, index) {
          final image = images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(image.path),
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 90,
                width: 90,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: const Text('AI Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ChatMessages(chatId: widget.chatId)),
            Consumer<ChatProvider>(
              builder: (_, chatProvider, __) {
                final images = chatProvider.imagesFileList;
                if (images != null && images.isNotEmpty) {
                  return _buildSelectedImages(images);
                }
                return const SizedBox.shrink();
              },
            ),
            BottomChatField(
              messageController: _messageController,
              focusNode: _focusNode,
              onSendPressed: _sendMessage,
              onImagePickPressed: _pickImages,
            ),
          ],
        ),
      ),
    );
  }
}

