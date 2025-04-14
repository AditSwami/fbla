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

  // Add a method to refresh classes from the database
  Future<void> _refreshClasses() async {
    try {
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
    } catch (e) {
      print("Error refreshing classes: $e");
    }
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
      ),
      // Wrap the body with CupertinoRefresh
      body: CupertinoRefresh(
        physics: const AlwaysScrollableScrollPhysics(),
        delayDuration: const Duration(seconds: 1),
        onRefresh: _refreshClasses,
        child: SingleChildScrollView(
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
      ),
    );
  }
}
