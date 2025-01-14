import 'package:fbla_2025/components/NavBar.dart';
import 'package:fbla_2025/pages/All_Classes.dart';
import 'package:fbla_2025/pages/Settings.dart';
import 'package:fbla_2025/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0; // State lifted to parent

  final List<Widget> screens = [
    const Homepage(),
    AllClasses(),
    SettingsActual(),
  ];

  void updateIndex(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screens[selectedIndex], // Display the selected screen
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: NavBar(
                selectedIndex: selectedIndex,
                onItemSelected: updateIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
