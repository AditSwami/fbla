import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/Services/Gemini.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/Buttons/animatedGradientBox.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Addunitpage extends StatefulWidget {
  Addunitpage({required this.clas});

  ClassData clas;
  @override
  State<Addunitpage> createState() => _AddunitpageState();
}

class _AddunitpageState extends State<Addunitpage> {
  TextEditingController _unitName = TextEditingController();
  TextEditingController _unitDescription = TextEditingController();

  String customId = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: false,
          title: Text(
            'Add Unit',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
             Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Button(
                height: 35,
                width: 100,
                onTap: () async {
                  UnitData unit = UnitData();
                  unit.description = _unitDescription.text;
                  unit.name = _unitName.text;
                  unit.id = customId;
                  unit.testScore = 0;
                  
                  await Firestore.addUnit(unit, widget.clas);
                  
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    'Add Unit',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Center(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Unit Name:',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _unitName,
                placeholder: 'Unit Name',
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppUi.grey.withOpacity(0.15)),
                style: TextStyle(color: AppUi.offWhite),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0),
              child: Text('Description:',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: CupertinoTextField(
                  controller: _unitDescription,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  placeholder: 'Description',
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppUi.grey.withOpacity(0.15)),
                  style: TextStyle(color: AppUi.offWhite, height: 1.5),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: Animatedgradientbox(
                      height: 40,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          'Generate',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                    onTap: () async {
                      String unitName = _unitName.text;
                      String? descriptionText = await Gemini.sendMessage(
                          "Please give me 30 word description of the $unitName unit. Don't mention the name of the unit in the beginning in astricks. Don't give me bullet points.  The descirption is for a small box that will be a container in an app that allows students to access units and flashcards.  Your word limit is 15.");
                      if (descriptionText != null) {
                        setState(() {
                          _unitDescription.text = descriptionText;
                        });
                      }
                    })),
              const SizedBox(
                height: 30,
              ),
            ]),
          ] 
        )
      )
    );
  }
}
