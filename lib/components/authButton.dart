import 'package:fbla_2025/Services/Firebase/firestore/Auth/Auth.dart';
import 'package:fbla_2025/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_ui.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.auth,
    this.action = 'sign in',
  });

  final String auth;
  final String action;

  @override
  Widget build(BuildContext context) {
    final authDetails = {
      'google': {
        'logo': 'assets/google_logo.png',
      },
      'apple': {
        'logo': 'assets/apple_logo_white.png',
      },
      'facebook': {
        'logo': 'assets/Facebook Logo.png',
      },
    };

    if (!authDetails.containsKey(auth)) {
      return const SizedBox.shrink();
    }

    final authInfo = authDetails[auth]!;
    final actionLabel = action == 'sign up' ? 'Sign up' : 'Sign in';

    return InkWell(
      onTap: () async {
        await Authentication.signInWithGoogle(context);
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => Homepage()),
            (route) => route.isFirst);
        // Add your onTap functionality here
      },
      child: Container(
        height: 45,
        width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppUi.grey.withOpacity(.2),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 30,
                width: 35,
                child: Image.asset(
                  authInfo['logo']!,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Text(
              '$actionLabel with ${auth[0].toUpperCase()}${auth.substring(1)}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
