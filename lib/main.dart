import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:fbla_2025/Services/firebase_options.dart';
import 'package:fbla_2025/pages/Main_Page.dart';
import 'package:fbla_2025/pages/auth/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/Services/Gemini.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Gemini.init();

    final fbu = FirebaseAuth.instance.currentUser;

    if (fbu != null) {
      UserData? user = await context.read<UserProvider>().getUser(fbu.uid);
      if (user != null) {
        context.read<UserProvider>().setCurentUser(user);
        context.read<UserProvider>().setAuth(true);
        context.read<UserProvider>().loadPosts(context);
        context.read<UserProvider>().loadUserPosts(context);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode,
      themeMode: ThemeMode.system,
      home: context.watch<UserProvider>().isAuth ? const MainPage() : Signup(),
    );
  }
}