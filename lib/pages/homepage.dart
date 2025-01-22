import 'package:cupertino_refresh/cupertino_refresh.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/class_box.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String searchText = ' ';
  List<ClassData> _createdClasses = [];
  List<ClassData> _joinedClasses = [];

  void init() {
    super.initState();
    Firestore.getUserCreatedClasses(context).then((clas) {
      setState(() {
         _createdClasses = clas!;
      });
    });
    Firestore.getUserClasses(context).then((clas) {
     setState(() {
        _joinedClasses = clas!;
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 112,
        backgroundColor: AppUi.backgroundDark,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'My Classes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SizedBox(
                width: 365,
                child: CupertinoSearchTextField(
                  backgroundColor: AppUi.grey.withValues(alpha: .1),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) => {},
                  onSubmitted: (value) {},
                  placeholder: 'Search',
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: CupertinoRefresh(
        physics: const AlwaysScrollableScrollPhysics(),
        delayDuration: const Duration(seconds: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
              ] +
              _createdClasses
                  .map((clas) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClassBox(
                              clas: clas,
                            ),
                          )
                        ],
                      ))
                  .toList(),
        ),
        onRefresh: () async {
          Firestore.getUserCreatedClasses(context).then((clas) {
            setState(() {
              _createdClasses = clas!;
            });
          });
          Firestore.getUserClasses(context).then((clas) {
            setState(() {
              _joinedClasses = clas!;
            });
          });
        },
      ),

    );
  }
}
