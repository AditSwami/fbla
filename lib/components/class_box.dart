import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/gradientBox.dart';

class ClassBox extends StatefulWidget {
  const ClassBox({Key? key, required this.className}) : super(key: key);

  final String className;

  @override
  State<ClassBox> createState() => _ClassBoxState();
}

class _ClassBoxState extends State<ClassBox> {
  @override
  Widget build(BuildContext context) {
    return Gradientbox(
      height: 121,
      width: 228,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 8),
                child: Text(
                  widget.className,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 48,
                    width: 198,
                    child: const Text('data'),
                  )
              ),
            ]
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, bottom: 65),
            child: GestureDetector(
              child: Container(
                height: 25,
                width: 50,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppUi.grey,
                  size: 28,
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
