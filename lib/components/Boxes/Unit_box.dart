import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/pages/TermsAndDefs/UnitPage.dart';
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
                builder: (context) => Unitpage(unit: widget.unit!, clas: widget.clas,)));
        print('Unit_box : ${widget.unit!.terms}');
        print('Unit_box name: ${widget.unit!.name}');

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
          ],
        ),
      ),
    );
  }
}
