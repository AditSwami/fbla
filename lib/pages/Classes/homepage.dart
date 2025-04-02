import 'package:cupertino_refresh/cupertino_refresh.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/pages/Classes/addClass_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/Boxes/class_box.dart';

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
      backgroundColor: AppUi.backgroundDark,
      appBar: AppBar(
        elevation: 12,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        backgroundColor: AppUi.backgroundDark,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Classes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Button(
                    height: 35,
                    width: 35,
                    color: AppUi.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const AddclassPage())
                      );
                    },
                    child: Icon(Icons.add, color: AppUi.offWhite, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppUi.grey.withOpacity(0.1),
                  border: Border.all(
                    color: AppUi.grey.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.transparent,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: _filterClasses,
                  controller: _searchController,
                  placeholder: 'Search classes...',
                  placeholderStyle: TextStyle(color: AppUi.grey.withOpacity(0.7)),
                  prefixIcon: Icon(CupertinoIcons.search, color: AppUi.grey.withOpacity(0.7)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CupertinoRefresh(
        physics: const BouncingScrollPhysics(),
        delayDuration: const Duration(milliseconds: 800),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        'Created Classes',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppUi.offWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: _filteredClasses
                      .map((clas) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, 
                              vertical: 8.0
                            ),
                            child: ClassBox(clas: clas),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        'Joined Classes',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppUi.offWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: _joinedClasses
                      .map((clas) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, 
                              vertical: 8.0
                            ),
                            child: ClassBox(clas: clas),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        onRefresh: () async {
          await Future.wait([
            Firestore.getUserCreatedClasses(context).then((clas) {
              setState(() {
                _createdClasses = clas ?? [];
                _filteredClasses = _createdClasses;
              });
            }),
            Firestore.getUserClasses(context).then((clas) {
              setState(() {
                _joinedClasses = clas ?? [];
              });
            }),
          ]);
        },
      ),
    );
  }
}
