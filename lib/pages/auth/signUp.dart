import 'package:fbla_2025/components/authButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_ui.dart';
import '../../components/button.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
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
              padding: const EdgeInsets.only(right: 260, bottom: 5),
              child: Text(
                'First Name:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 360,
              child: CupertinoTextField(
                controller: _firstName,
                placeholder: 'First Name',
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
              padding: const EdgeInsets.only(right: 265, bottom: 5),
              child: Text(
                'Last Name:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 360,
              child: CupertinoTextField(
                controller: _lastName,
                placeholder: 'Last Name',
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
                  Text('Sign up',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppUi.backgroundDark)),
                ],
              ),
              onTap: () {
                
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
                    color: AppUi.grey.withOpacity(.4),
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
            )
          ],
        ),
      ),
    );
  }
}
