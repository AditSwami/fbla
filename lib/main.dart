import 'package:fbla_2025/firebase_options.dart';
import 'package:fbla_2025/pages/addClass_page.dart';
import 'package:fbla_2025/pages/auth/logIn.dart';
import 'package:fbla_2025/pages/auth/signUp.dart';
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
      home: Signup(),
      onGenerateRoute: (settings) {
        if (settings.name == '/class') {
          final className = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ClassPage(className: className),
          );
        }
        return null;
      },
      routes: {
        '/home': (context) => const Homepage(),
        '/newClass': (context) => const AddclassPage(),
        '/signUp': (context) => Signup(),
        '/login': (context) => Login()
      },
    );
  }
}
