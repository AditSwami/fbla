import 'package:fbla_2025/Services/Firebase/firestore/Auth/Auth.dart';
import 'package:fbla_2025/components/button.dart';
import 'package:fbla_2025/pages/auth/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Account Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Button(
              height: 30,
              width: 200,
              onTap: () async {
                Authentication.logOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => Signup()),
                    (route) => route.isFirst);
              },
            )
          ],
        ),
      ),
    );
  }
}
