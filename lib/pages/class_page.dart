import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/unitBox.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key, required this.className});

  final String className;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        //utomaticallyImplyLeading: false,
        backgroundColor: AppUi.backgroundDark,
        title: Text(
          className,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
      body: const Center(
        child: Column(
          children: [
            Unitbox()
          ],
        ),
      ),
    );
  }
}
