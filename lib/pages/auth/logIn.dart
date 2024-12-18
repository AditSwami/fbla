import 'package:fbla_2025/components/authButton.dart';
import 'package:fbla_2025/components/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_ui.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 300, bottom: 5),
              child: Text(
                'Email:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 360,
              child: CupertinoTextField(
                controller: _email,
                placeholder: 'Email',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppUi.grey.withOpacity(.2),
                ),
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
                placeholder: 'Password',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppUi.grey.withOpacity(.2),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              color: AppUi.primary.withOpacity(.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Log in',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppUi.backgroundDark)
                  ),
                ],
              ),
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
                    thickness: 2,
                    color: AppUi.grey.withOpacity(.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'OR',
                    style: Theme.of(context).textTheme.titleSmall
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: AppUi.grey.withOpacity(.4),
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
              padding: EdgeInsets.only(bottom: 15,),
              child: AuthButton(auth: 'google'),
            ),
            const Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: AuthButton(auth: 'apple'),
            ),
            const AuthButton(auth: 'facebook')
          ],
        ),
      ),
    );
  }
}
