import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/material.dart';

class AddClass extends StatelessWidget {
  const AddClass({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 60,
        width: 328,
        decoration: BoxDecoration(
            color: AppUi.grey.withOpacity(.3),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Column(
            children: [
              Text(
                'Add New Class',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/newClass');
      },
    );
  }
}
