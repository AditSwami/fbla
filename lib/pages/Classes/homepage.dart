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
  String searchText = '';
  List<ClassData> _createdClasses = [];

   List<ClassData> _filteredClasses = [];

  final TextEditingController _searchController = TextEditingController();

  List<ClassData> _joinedClasses = [];

    @override
  void initState() {
    super.initState();
    if(mounted) {
      Firestore.getUserCreatedClasses(context).then((clas) {
        setState(() {
          _createdClasses = clas ?? [];
          _filteredClasses = _createdClasses; // Move this inside setState
        });
      });
      Firestore.getUserClasses(context).then((clas) {
        setState(() {
          _joinedClasses = clas ?? [];
        });
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();  // Add this
    super.dispose();
  }

  void _filterClasses(String query) {
    setState(() {
      searchText = query;
      if (query.isEmpty) {
        _filteredClasses = _createdClasses;
      } else {
        _filteredClasses = _createdClasses
            .where((clas) => clas.name.toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
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
                  backgroundColor: AppUi.grey.withAlpha(26),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: _filterClasses,
                  controller: _searchController,
                  placeholder: 'Search classes',
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
        child: SingleChildScrollView(  // Add this wrapper
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Created Classes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppUi.primary,
                  ),
                ),
              ),
              Column(
                children: _filteredClasses
                    .map((clas) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClassBox(clas: clas),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Joined Classes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppUi.primary,
                  ),
                ),
              ),
              Column(
                children: _joinedClasses
                    .map((clas) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClassBox(clas: clas),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          await Firestore.getUserCreatedClasses(context).then((clas) {
            setState(() {
              _createdClasses = clas ?? [];
              _filteredClasses = _createdClasses;
            });
          });
          await Firestore.getUserClasses(context).then((clas) {
            setState(() {
              _joinedClasses = clas ?? [];
            });
          });
        },
      ),
    );
  }
}
