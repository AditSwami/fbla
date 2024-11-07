import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/class_box.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String searchText = ' ';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppUi.backgroundDark,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 30),
          child: Text(
            'Classes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        centerTitle: false,
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            ClassBox(className: 'hello'),
            SizedBox(
              height: 16,
            ),
            ClassBox(className: 'hello'),
            SizedBox(
              height: 16,
            ),
            ClassBox(className: 'hello'),
          ],
        ),
      ),
    );
  }
}
