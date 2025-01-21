import 'package:fbla_2025/pages/class_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class ClassBox extends StatefulWidget {
   ClassBox({Key? key, required this.className, required this.progress})
      : super(key: key);

  String className;
  String progress;

  @override
  State<ClassBox> createState() => _ClassBoxState();
}

class _ClassBoxState extends State<ClassBox> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ClassPage(className: widget.className)));
      },
      child: Container(
              height: 121,
              width: 370,
              decoration: BoxDecoration(
                color: AppUi.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, top: 13, left: 18),
                        child: Text(
                          widget.className,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Container(
                          constraints: const BoxConstraints(
                              maxWidth: 300, maxHeight: 60),
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
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => ClassPage(className: widget.className))
                        );
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
            ),
    );
  }
}
