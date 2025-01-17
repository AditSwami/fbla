import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/components/animatedGradientBox.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Gemini.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:provider/provider.dart';

class AddclassPage extends StatefulWidget {
  const AddclassPage({super.key});

  @override
  State<AddclassPage> createState() => _AddclassPageState();
}

class _AddclassPageState extends State<AddclassPage> {
  final TextEditingController _className = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

  String customId = DateTime.now().millisecondsSinceEpoch.toString();
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
              controller: _description,
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
                  height:40,
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
                  String className = _className.text;
                  String? descriptionText = await Gemini.sendMessage(
                      "Please give me 30 word description of the $className class. Don't mention the name of the class in the beginning in astricks. Don't give me bullet points.  The descirption is for a small box that will be a container in an app that allows students to access units and flashcards.  Your word limit is 15.");
                  if (descriptionText != null) {
                    setState(() {
                      _description.text = descriptionText;
                    });
                  }
                })),
                const SizedBox(
                  height: 30,
                ),
        GestureDetector(
          child: Container(
            height: 30,
            width: 50,
            color: AppUi.grey,
          ),
          onTap: () {
            ClassData clas = ClassData();
            UserData? user = context.read<UserProvider>().currentUser;
            clas.creator = user.id;
            clas.description = _description.text;
            clas.dateMade = DateTime.now();
            clas.name = _className.text;
            clas.id = customId;

            Firestore.addClass(clas);

            Navigator.pop(context);
          },
        )
      ]),
    );
  }
}
