import 'package:cupertino_refresh/cupertino_refresh.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/Unit_box.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/class_box.dart';
import 'package:fbla_2025/components/gradientBox.dart';
import 'package:fbla_2025/pages/Units/AddUnitPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatefulWidget {
  ClassPage({super.key, required this.clas});

  final ClassData clas;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  String unitName = '';
  String unitDescirption = '';
  List<UnitData?> _units = [];

  void initState() {
    super.initState();
    Firestore.getUnits(context, widget.clas).then((unit) {
      setState(() {
        _units = unit!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 120,
        backgroundColor: AppUi.backgroundDark,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 35,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    widget.clas.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 45.0, right: 15.0),
            child: GestureDetector(
              child: Icon(
                Icons.add,
                color: AppUi.primary,
                size: 35,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => Addunitpage(
                              clas: widget.clas,
                            )));
              },
            ),
          )
        ],
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
              _units
                  .map((value) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: UnitBox(
                              unit: value,
                              clas: widget.clas,
                            ),
                          )
                        ],
                      ))
                  .toList(),
        ),
        onRefresh: () async {
          Firestore.getUnits(context, widget.clas).then((unit) {
            setState(() {
              _units = unit!;
            });
          });
        },
      ),
    );
  }
}
