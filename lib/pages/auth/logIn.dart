import 'package:fbla_2025/Services/Firebase/firestore/Auth/Auth.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/components/Auth/authButton.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:fbla_2025/pages/Classes/homepage.dart';
import 'package:fbla_2025/pages/auth/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                style: Theme.of(context).textTheme.bodyLarge,
                 decoration: BoxDecoration(
                  color : AppUi.grey.withValues(alpha: .1),
                    border: Border.all(
                      color: AppUi.grey.withOpacity(0.2),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                style: Theme.of(context).textTheme.bodyLarge,
                 decoration: BoxDecoration(
                  color : AppUi.grey.withValues(alpha: .1),
                    border: Border.all(
                      color: AppUi.grey.withOpacity(0.2),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              height: 40,
              width: 360,
              color: AppUi.primary.withOpacity(.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Log in',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge),
                ],
              ),
              onTap: () async {
                UserData? u = await Authentication.signInWithEmail(
                    _email.text, _password.text, context);

                context.read<UserProvider>().setCurentUser(u!);
                context.read<UserProvider>().setAuth(true);
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => Homepage()));
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
                    thickness: 2,
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
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: AuthButton(auth: 'google'),
            ),
            const SizedBox(height: 30,),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium),
              TextSpan(
                  text: 'Sign up',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => Signup())
                      );
                    })
            ]))
          ],
        ),
      ),
    );
  }
}
