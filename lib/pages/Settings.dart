import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsActual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        centerTitle: false,
        
      ),
    );
  }
}
