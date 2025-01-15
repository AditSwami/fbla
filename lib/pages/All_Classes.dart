import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/pages/addClass_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/class_box.dart';

class AllClasses extends StatefulWidget {
  @override
  State<AllClasses> createState() => _AllClassesState();
}

class _AllClassesState extends State<AllClasses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 110,
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
                    CupertinoPageRoute(builder: (context) => AddclassPage()));
              },
            ),
          )
        ],
        centerTitle: false,
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(
                  className: 'hello',
                  progress: 'bad',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
