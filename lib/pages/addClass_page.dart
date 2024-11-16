import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbla_2025/Services/database.dart';
import 'package:fbla_2025/Services/Gemini.dart';
import 'package:fbla_2025/app_ui.dart';

class AddclassPage extends StatefulWidget {
  const AddclassPage({super.key});

  @override
  State<AddclassPage> createState() => _AddclassPageState();
}

class _AddclassPageState extends State<AddclassPage> {
  final TextEditingController _className = new TextEditingController();
  final TextEditingController _description = new TextEditingController();
  //final TextEditingController _creator = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: false,
        title: Text(
          'Add Class',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Class Name:',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoTextField(
            controller: _className,
            placeholder: 'Class Name',
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppUi.grey.withOpacity(0.3)),
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
              controller: _description,
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              placeholder: 'Description',
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppUi.grey.withOpacity(0.3)),
              style: TextStyle(color: AppUi.offWhite, height: 1.5),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                child: Container(
                  height: 30,
                  width: 150,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppUi.primary),
                      borderRadius: BorderRadius.circular(10),
                      color: AppUi.backgroundDark,
                      boxShadow: [
                        BoxShadow(
                          color: AppUi.primary.withOpacity(.5)
                              .withOpacity(0.6),
                          blurRadius: 6.0,
                          spreadRadius: 3.0,
                        )
                      ]),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Generate',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  String className = _className.text;
                  String? descriptionText = await Gemini.sendMessage(
                      "Please give me 30 word description of the $className class. Don't mention the name of the class in the beginning in astricks. Don't give me bullet points.  The descirption is for a small box that will be a container in an app that allows students to access units and flashcards");
                  if (descriptionText != null) {
                    setState(() {
                      _description.text = descriptionText;
                    });
                  }
                })),
        GestureDetector(
          child: Container(
            height: 30,
            width: 50,
            color: AppUi.grey,
          ),
          onTap: () {
            ClassData(
                classDescription: _description.text,
                className: _className.text,
                dateMade: DateTime.now(),
                creator: 'me').toFirestore();
          },
        )
      ]),
    );
  }
}
