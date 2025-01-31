import 'package:fbla_2025/pages/Chat/ChatPage.dart';
import 'package:fbla_2025/pages/Classes/All_Classes.dart';
import 'package:fbla_2025/pages/Settings_Page/Settings.dart';
import 'package:fbla_2025/pages/Classes/homepage.dart';
import 'package:flutter/material.dart';

import '../app_ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const Homepage(),
    AllClasses(),
    SettingsActual(),
    Chatpage()
  ];

  void updateIndex(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[600],
        //type: BottomNavigationBarType.shifting,
        elevation: 8,
        currentIndex: selectedIndex,
        onTap: updateIndex,
        selectedItemColor: AppUi.primary,
        unselectedItemColor: Colors.grey, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
