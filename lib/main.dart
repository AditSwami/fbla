import 'package:flutter/material.dart';

import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/pages/homepage.dart';
import 'package:fbla_2025/pages/class_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkMode,
      themeMode: ThemeMode.system,
      home: const Homepage(),
      routes: {
        '/home': (context) => Homepage(),
        '/class': (context) => ClassPage(),
      },
    );
  }
}
