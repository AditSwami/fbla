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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 230.0),
                child: Text(
                  'Created classes',
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad',),
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(className: 'hello', progress: 'bad'),
            ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 240.0),
                child: Text('Joined classes',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(
                  className: 'hello',
                  progress: 'bad',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(
                  className: 'hello',
                  progress: 'bad',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(
                  className: 'hello',
                  progress: 'bad',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ClassBox(
                  className: 'hello',
                  progress: 'bad',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
