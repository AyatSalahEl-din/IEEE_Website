import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/chat_provider.dart';
import '../chatbot_models/message.dart';

class ChatMessages extends StatefulWidget {
  final String chatId;
  const ChatMessages({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (dateToCheck == today) {
      return DateFormat.Hm().format(timestamp);
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (chatProvider.isLoading) {
            _scrollToBottom();
          }
        });

        if (chatProvider.inChatMessages.isEmpty) {
          return const Center(
            child: Text('No messages yet. Start a conversation!'),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: chatProvider.inChatMessages.length,
          itemBuilder: (context, index) {
            final message = chatProvider.inChatMessages[index];
            return _buildMessageTile(message, context);
          },
        );
      },
    );
  }

  Widget _buildMessageTile(Message message, BuildContext context) {
    final isUser = message.role == Role.user;
    final timestamp = _formatTimestamp(message.timeSent);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: isUser ? Colors.blue[400] : Colors.grey[300],
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.imagesUrls.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: message.imagesUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  message.imagesUrls[index],
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (message.imagesUrls.isNotEmpty)
                      const SizedBox(height: 8),

                    SelectableText(
                      message.message.toString(),
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUser ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}