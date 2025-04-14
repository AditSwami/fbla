import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/components/Buttons/animatedGradientBox.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
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
  final TextEditingController _className = TextEditingController();
  final TextEditingController _description = TextEditingController();

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
        actions: [
          Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Button(
            height: 35,
            width: 100,
            onTap: () async {
              try {
                ClassData clas = ClassData();
                UserData? user = context.read<UserProvider>().currentUser;
                clas.creator = "${user.firstName} ${user.lastName}";
                clas.description = _description.text;
                clas.dateMade = DateTime.now();
                clas.name = _className.text;
                clas.id = customId;
        
                await Firestore.addClass(clas);
                context.read<UserProvider>().addClass(clas);
                Navigator.pop(context, true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding class: $e')),
                );
              }
            },
            child: Center(
              child: Text(
                'Add Class',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        )
        ],
      ),
      // Wrap the body in a SingleChildScrollView to handle keyboard overflow
      body: SingleChildScrollView(
        // Add padding to ensure content doesn't get hidden behind keyboard
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              }
            )
          ),
          const SizedBox(
            height: 30,
          ),
        ]),
      ),
      // Add resizeToAvoidBottomInset to ensure the screen resizes when keyboard appears
      resizeToAvoidBottomInset: true,
    );
  }
}
