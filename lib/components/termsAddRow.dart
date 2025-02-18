import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/Unit_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAddRow extends StatelessWidget{
  TermsAddRow({super.key, required this.unit});

  UnitData unit;
  final TextEditingController _term = TextEditingController();
  final TextEditingController _definition = TextEditingController();
    @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppUi.grey.withValues(alpha: .1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Term:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          //term
          Container(
            height: 30,
            width: 120,
            child: CupertinoTextField(
              controller: _term,
              placeholder: 'Term',
              style: Theme.of(context).textTheme.bodyMedium,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Text(
            'Term:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          //def
          Container(
            height: 30,
            width: 120,
            child: CupertinoTextField(
              controller: _definition,
              placeholder: 'Definition',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}