import 'package:flutter/material.dart';

import '../app_ui.dart';

class SettingsActual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        centerTitle: false
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 30, bottom: 30),
                  child: CircleAvatar(
                    backgroundColor: AppUi.grey.withValues(alpha: 0.1),
                    radius: 55,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 30),
                      child: Text(
                        'Classes Created:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, right: 26),
                      child: Text(
                        'Followers:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ]
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Account',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppUi.grey.withValues(alpha: .5)
                      )
                    )
                  ),
                  child:  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Journey Rules',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Privacy',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Terms and Conditions',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Help Center',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Report a bug',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppUi.grey.withValues(alpha: .5)))),
                  child: Text(
                    'Delete Account',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.red),
                  ),
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
