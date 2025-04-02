import 'package:flutter/cupertino.dart';  // Add this import
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppUi.grey.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: CupertinoTabBar(
          backgroundColor: AppUi.backgroundDark.withOpacity(0.3),
          activeColor: AppUi.primary,
          inactiveColor: AppUi.grey,
          currentIndex: selectedIndex,
          iconSize: 22, // Added smaller icon size
          onTap: updateIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class_outlined),
              label: 'Classes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
