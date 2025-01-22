import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/pages/class_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

// ignore: must_be_immutable
class UnitBox extends StatefulWidget {
  UnitBox({super.key, required this.unit, required this.clas});

  UnitData? unit;
  ClassData clas;

  @override
  State<UnitBox> createState() => _ClassBoxState();
}

class _ClassBoxState extends State<UnitBox> {
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
                builder: (context) => ClassPage(clas: widget.clas)));
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
                  padding: const EdgeInsets.only(bottom: 5, top: 13, left: 18),
                  child: Text(
                    widget.unit!.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 300, maxHeight: 60),
                    child: Text(
                      widget.unit!.description,
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
                      CupertinoPageRoute(
                          builder: (context) => ClassPage(clas: widget.clas)));
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
