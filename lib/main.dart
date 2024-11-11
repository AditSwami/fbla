import 'package:fbla_2025/firebase_options.dart';
import 'package:fbla_2025/pages/addClass_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/pages/homepage.dart';
import 'package:fbla_2025/pages/class_page.dart';
import 'package:fbla_2025/Services/Gemini.dart';

void main() async {
  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Gemini.init();
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
        '/home': (context) => const Homepage(),
        '/class': (context) => ClassPage(className: ''),
        '/newClass': (context) => const AddclassPage()
      },
    );
  }
}
