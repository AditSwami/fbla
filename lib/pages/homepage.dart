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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(
                'Created classes',
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Joined classes',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        ),
      ),
    );
  }
}
