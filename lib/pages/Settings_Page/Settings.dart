import 'package:fbla_2025/Services/Firebase/firestore/Auth/Auth.dart';
import 'package:fbla_2025/pages/Settings_Page/help_center.dart'; // Add this import
import 'package:fbla_2025/pages/Settings_Page/privacy_policy.dart';
import 'package:fbla_2025/pages/Settings_Page/terms_and_conditions.dart';
import 'package:fbla_2025/pages/auth/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_ui.dart';

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
        centerTitle: false,
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
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => PrivacyPolicyPage())),
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
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => TermsAndConditionsPage())),
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
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => HelpCenterPage())),
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
                    'Log Out',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                onTap: () {
                  Authentication.logOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => Signup()),
                      (route) => route.isFirst);
                },
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
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
