import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import 'constants.dart';
import 'chat_screen.dart';

class ChatbotHomeScreen extends StatefulWidget {
  static const String routeName = 'Chatbothomescreen';
  final TabController? tabController;
  const ChatbotHomeScreen({Key? key, this.tabController}) : super(key: key);

  @override
  State<ChatbotHomeScreen> createState() => _ChatbotHomeScreenState();
}

class _ChatbotHomeScreenState extends State<ChatbotHomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await ChatProvider.initHive();
    // Any other initialization can go here
  }

  @override
  Widget build(BuildContext context) {
    // Get current screen dimensions
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3),
        title: const Text('Chatbot'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // Use SingleChildScrollView to enable scrolling if content exceeds screen size
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            // Set minimum height to fill the screen properly
            height: screenSize.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Use Spacer to push content down slightly
                const Spacer(flex: 1),

                // Logo image with relative size based on screen dimensions
                SizedBox(
                  height: screenSize.height * 0.15,
                  child: Image.asset(
                    'assets/images/chat_logo.png',
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.chat,
                        size: 80,
                        color: Colors.blue,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Welcome text
                Text(
                  'Welcome to Your AI Assistant',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Brief description
                Text(
                  'Ask me anything or upload images for analysis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                // Start new chat button
                ElevatedButton(
                  onPressed: () {
                    final newChatId = DateTime.now().millisecondsSinceEpoch.toString();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatId: newChatId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Start New Chat',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Use Spacer at the end to distribute remaining space
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}