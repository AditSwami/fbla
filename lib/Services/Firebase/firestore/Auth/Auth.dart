import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/components/utils.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Authentication {
  static Future<UserData?> signUpwithEmail(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlert(
            "Weak Password",
            "The password provided is too weak. Please choose a different password.",
            context);
      } else if (e.code == 'email-already-in-use') {
        showAlert(
            "Email In Use",
            "An account already exists for the email ${email}. Try the log in button.",
            context);
      } else if (e.code == 'invalid-email') {
        showAlert(
            "Invalid Email",
            "The email you have entered is not a valid email address.",
            context);
      } else {
        print(e.code);
      }
    } catch (e) {
      print(e);
    }

    if (FirebaseAuth.instance.currentUser != null) {
      UserData? user = await context
          .read<UserProvider>()
          .getUser(FirebaseAuth.instance.currentUser!.uid);
      return user;
    } else {
      return null;
    }
  }

  static Future<UserData?> signInWithEmail(
      String email, String pswrd, BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pswrd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlert(
            "Account Not Found",
            "We can't find an account linked to the email ${email}. Sign up to register one.",
            context);
      } else if (e.code == 'wrong-password') {
        showAlert(
            "Incorrect Password",
            "That is not the correct password for the account linked to ${email}.",
            context);
      } else if (e.code == 'too-many-requests') {
        showAlert(
            "Too Many Requests",
            "You've entered the wrong password too many times. Please try again later.",
            context);
      } else if (e.code == 'invalid-credential') {
        showAlert("Incorrect Credentials",
            "This username and password do not match an account.", context);
      } else if (e.code == 'invalid-email') {
        showAlert("Invalid Email", "The email you input is invalid", context);
      } else {
        print(e.code);
      }
    } catch (e) {
      print(e);
    }

    if (FirebaseAuth.instance.currentUser != null) {
      UserData? user = await context
          .read<UserProvider>()
          .getUser(FirebaseAuth.instance.currentUser!.uid);
      return user;
    } else {
      return null;
    }
  }

  static Future<UserData?> signInWithGoogle(BuildContext context) async {
    UserData? user = UserData();

    final gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    final fbuCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final fbu = fbuCred.user;

    if (fbu == null) return null;

    final fsu = await Firestore.getUser(fbu.uid);

    if (fsu == null) return null;

    user = await context.read<UserProvider>().getUser(fsu.id);

    return user;
  }

  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
