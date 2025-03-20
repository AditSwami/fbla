import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAddRow extends StatelessWidget {
  TermsAddRow({super.key, required this.unit});

  final UnitData unit;
  // Make controllers accessible
  final TextEditingController term = TextEditingController();
  final TextEditingController definition = TextEditingController();

  // Update the CupertinoTextField controllers
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 60,
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
            height: 40,
            width: 120,
            child: CupertinoTextField(
              controller: term,  // Updated from _term
              placeholder: 'Term',
              style: Theme.of(context).textTheme.bodyMedium,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Text(
            'Definition:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          //def
          Container(
            height: 40,
            width: 120,
            child: CupertinoTextField(
              controller: definition,  // Updated from _definition
              placeholder: 'Definition',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}