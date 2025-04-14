import 'package:cupertino_refresh/cupertino_refresh.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/Firebase/firestore/classes.dart';
import '../../components/Boxes/class_box.dart';

class AllClasses extends StatefulWidget {
  const AllClasses({super.key});

  @override
  State<AllClasses> createState() => _AllClassesState();
}

class _AllClassesState extends State<AllClasses> {
  List<ClassData> _classes = [];
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getClasses(context).then((classes) {
      setState(() {
        _classes = classes ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 121,
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
                'Classes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0),
              child: SizedBox(
                width: 370,
                child: CupertinoSearchTextField(
                  decoration: BoxDecoration(
                  color : AppUi.grey.withValues(alpha: .1),
                    border: Border.all(
                      color: AppUi.grey.withOpacity(0.2),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
        delayDuration: const Duration(
          seconds: 1
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            const SizedBox(
              height: 10,
            ),
          ] + _classes.map((clas) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClassBox(clas: clas,),
              )
            ],
          )).toList(),
        ),
        onRefresh: () async {
          Firestore.getClasses(context).then((classes) {
            setState(() {
              _classes = classes ?? [];
            });
          });
        },
      ),
    );
  }
}
