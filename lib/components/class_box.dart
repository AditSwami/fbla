import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/animatedGradientBox.dart';

class ClassBox extends StatelessWidget {
  const ClassBox({Key? key, required this.className}) : super(key: key);

  final String className;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 121,
      width: 328,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppUi.grey),
        color: AppUi.backgroundDark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  className,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 8),
                  child: Animatedgradientbox(height: 60, width: 150),
              ),
            ]
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, bottom: 65),
            child: GestureDetector(
              child: Container(
                height: 25,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppUi.primary,
                ),
                child: Icon(
                  Icons.arrow_right_alt,
                  color: AppUi.backgroundDark,
                  size: 35,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/class');
              },
            ),
          ),
        ],
      ),
    );
  }
}
