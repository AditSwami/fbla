import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/class_box.dart';
import 'package:fbla_2025/components/gradientBox.dart';
import 'package:fbla_2025/pages/Settings_Page/AddUnitPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  ClassPage({super.key, required this.className});

  final String className;
  String unitName = '';
  String unitDescirption = '';

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
                    className,
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
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Addunitpage()));
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [ClassBox(className: unitName, progress: unitDescirption)],
        ),
      ),
    );
  }
}
