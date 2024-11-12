import 'package:fbla_2025/components/add_class.dart';
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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ClassBox(className: 'hello', progress: 'bad',),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ClassBox(className: 'hello', progress: 'bad'),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ClassBox(className: 'hello', progress: 'bad'),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: AddClass()
            )
          ],
        ),
      ),
    );
  }
}
