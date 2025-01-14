import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/gradientBox.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key, required this.className});

  final String className;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        //automaticallyImplyLeading: false,
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
            Gradientbox(height: 10,width: 10,)
          ],
        ),
      ),
    );
  }
}
