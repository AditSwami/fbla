import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_ui.dart';
import '../components/button.dart';

class Register extends StatelessWidget {
  Register({super.key, required email});

  final TextEditingController _firstN = TextEditingController();
  final TextEditingController __lastN = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        backgroundColor: AppUi.backgroundDark,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 30),
          child: Text(
            'Create Account',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        centerTitle: false,
      ),
      //body
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CircleAvatar(
                radius: 150,
                backgroundColor: AppUi.grey.withValues(alpha: .2),
                child: const Icon(
                  Icons.person,
                  size: 200,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 5),
                      child: Text(
                        'First Name:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: CupertinoTextField(
                        controller: _firstN,
                        style: Theme.of(context).textTheme.bodyLarge,
                        placeholder: 'First Name',
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppUi.grey.withValues(alpha: .2),
                        ),
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 5),
                  child: Text(
                    'Last Name:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: CupertinoTextField(
                    controller: __lastN,
                    style: Theme.of(context).textTheme.bodyLarge,
                    placeholder: 'Last Name',
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppUi.grey.withValues(alpha: .2),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                )
              ])
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Button(
                color: AppUi.primary.withValues(alpha: .8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppUi.backgroundDark)),
                  ],
                ),
                onTap: () async {
                  UserData user = UserData();
                  user.firstName = _firstN.text;
                  user.lastName = __lastN.text;
                  user.classes = [];
                  user.pfp = "";

                  Firestore.registerUser(user);

                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const Homepage()));
                }),
          ),
        ],
      ),
    );
  }
}
