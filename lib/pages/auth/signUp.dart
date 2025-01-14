import 'package:fbla_2025/Services/Firebase/firestore/Auth/Auth.dart';
import 'package:fbla_2025/components/authButton.dart';
import 'package:fbla_2025/pages/Register.dart';
import 'package:fbla_2025/pages/auth/logIn.dart';
import 'package:fbla_2025/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../Services/Firebase/firestore/classes.dart';
import '../../app_ui.dart';
import '../../Services/auth.dart';
import '../../components/button.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 310, bottom: 5),
              child: Text(
                'Email:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 360,
              child: CupertinoTextField(
                controller: _email,
                style: Theme.of(context).textTheme.bodyLarge,
                placeholder: 'Email',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppUi.grey.withValues(alpha: .2),
                ),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 270, bottom: 5),
              child: Text(
                'Password:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 360,
              child: CupertinoTextField(
                controller: _password,
                style: Theme.of(context).textTheme.bodyLarge,
                placeholder: 'Password',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppUi.grey.withValues(alpha: .2),
                ),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              color: AppUi.primary.withValues(alpha: .8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign up',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppUi.backgroundDark)),
                ],
              ),
              onTap: () async {
                UserData? u = await Authentication.signUpwithEmail(
                    _email.text, _password.text, context);
                if (u == null && FirebaseAuth.instance.currentUser != null) {
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => Register(email: _email.text,)));
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Divider(
                    thickness: 1.5,
                    color: AppUi.grey.withValues(alpha: .4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('OR', style: Theme.of(context).textTheme.titleSmall),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1.5,
                    color: AppUi.grey.withValues(alpha: .4),
                  ),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: AuthButton(
                auth: 'google',
                action: 'sign up',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: AuthButton(
                auth: 'apple',
                action: 'sign up',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: AuthButton(
                auth: 'facebook',
                action: 'sign up',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium),
              TextSpan(
                  text: 'Sign in',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => Login())
                      );
                    })
            ]))
          ],
        ),
      ),
    );
  }
}
