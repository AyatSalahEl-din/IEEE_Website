import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:provider/provider.dart';

import '../chatbot_widgets/bottom_chat_field.dart';
import '../chatbot_widgets/chat_messages.dart';
import '../provider/chat_provider.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.inChatMessages.isNotEmpty) {
          _scrollToBottom();
        }

        // auto scroll to bottom on new message
        chatProvider.addListener(() {
          if (chatProvider.inChatMessages.isNotEmpty) {
            _scrollToBottom();
          }
        });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: WebsiteColors.primaryBlueColor,

            centerTitle: true,
            title:  Text('Chat with Gemini',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: WebsiteColors.whiteColor),),
            actions: [
              if (chatProvider.inChatMessages.isNotEmpty)
                Padding(
                  padding:  EdgeInsets.all(8.0.sp),
                  child: CircleAvatar(backgroundColor: WebsiteColors.whiteColor,
                    child: IconButton(
                      icon:  Icon(Icons.add),
                      onPressed: () async {
                        // show my animated dialog to start new chat
                        // showMyAnimatedDialog(
                        //   context: context,
                        //   title: 'Start New Chat',
                        //   content: 'Are you sure you want to start a new chat?',
                        //   actionText: 'Yes',
                        //   onActionPressed: (value) async {
                        //     if (value) {
                        //       // prepare chat room
                        //       await chatProvider.prepareChatRoom(
                        //           isNewChat: true, chatID: '');
                        //     }
                        //   },
                        // );
                      },
                    ),
                  ),
                )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding:  EdgeInsets.all(20.0.sp),
              child: Column(
                children: [
                  Expanded(
                    child: chatProvider.inChatMessages.isEmpty
                        ?  Center(
                      child: Text('No messages yet',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: WebsiteColors.primaryBlueColor),),
                    )
                        : ChatMessages(
                      scrollController: _scrollController,
                      chatProvider: chatProvider,
                    ),
                  ),

                  // input field
                  BottomChatField(
                    chatProvider: chatProvider,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}