import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/gradientBox.dart';

class ClassBox extends StatefulWidget {
  const ClassBox({Key? key, required this.className, required this.progress})
      : super(key: key);

  final String className;
  final String progress;

  @override
  State<ClassBox> createState() => _ClassBoxState();
}

class _ClassBoxState extends State<ClassBox> {
  @override
  Widget build(BuildContext context) {
    return Gradientbox(
      height: 121,
      width: 328,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 13, left: 18),
                child: Text(
                  widget.className,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 8),
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 200, maxHeight: 60),
                  child: Text(
                    widget.progress,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, bottom: 65),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.pushNamed(context, '/class',
                    arguments: widget.className);
              },
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppUi.grey,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
