import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Unitpage extends StatefulWidget {
  Unitpage({super.key, required this.unit});

  UnitData unit;

  @override
  State<Unitpage> createState() => _UnitpageState();
}

class _UnitpageState extends State<Unitpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 60,
        backgroundColor: AppUi.backgroundDark,
        title: Text(
          widget.unit.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
    );
  }
}
