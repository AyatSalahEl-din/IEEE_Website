import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:ieee_website/chatbot/profile_screen.dart';
import 'package:ieee_website/chatbot/chat_history_screen.dart';
import 'package:ieee_website/chatbot/chat_screen.dart';

class ChatbotHomeScreen extends StatefulWidget {
  const ChatbotHomeScreen({super.key});
  static const String routeName = 'chatbot_home';

  @override
  ChatbotHomeScreenState createState() => ChatbotHomeScreenState();
}

class ChatbotHomeScreenState extends State<ChatbotHomeScreen> {
  // Page controller for the PageView
  final PageController _pageController = PageController();

  // List of screens (pages)
  final List<Widget> _screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  // Currently selected bottom nav index
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 0,
        selectedItemColor: WebsiteColors.primaryBlueColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Chat History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
