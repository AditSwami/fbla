import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/class_box.dart';

import '../components/button.dart';

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
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ClassBox(className: 'hello', progress: 'bad',),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ClassBox(className: 'hello', progress: 'bad'),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ClassBox(className: 'hello', progress: 'bad'),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                height: 60,
                width: 370,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add New Class',
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
