import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';

class BottomChatField extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final VoidCallback onSendPressed;
  final VoidCallback onImagePickPressed;

  const BottomChatField({
    Key? key,
    required this.messageController,
    required this.focusNode,
    required this.onSendPressed,
    required this.onImagePickPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: onImagePickPressed,
            color: Colors.blue,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSendPressed(),
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return IconButton(
                icon: chatProvider.isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blue,
                  ),
                )
                    : const Icon(Icons.send),
                onPressed: chatProvider.isLoading ? null : onSendPressed,
                color: Colors.blue,
              );
            },
          ),
        ],
      ),
    );
  }
}