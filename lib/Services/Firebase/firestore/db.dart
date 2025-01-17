import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../data/Provider.dart';

class Firestore {
  static final db = FirebaseFirestore.instance;

  static Future<UserData?> getUser(String uid,
      [DocumentSnapshot<Map<String, dynamic>>? snap]) async {
    UserData user = UserData();

    final User fbu = FirebaseAuth.instance.currentUser!;
    user.email = fbu.email ?? "";
    user.id = fbu.uid;

    final docRef = db.collection('users').doc(uid);
    final docSnap = snap ?? await docRef.get();

    if (!docSnap.exists) {
      return null;
    }

    var data = docSnap.data();

    user.firstName = data?['firstname'];
    user.lastName = data?['lastname'];
    user.email = data?['email'];
    user.pfp = data?['pfp'];

    for (var clas in data?['classes'] ?? []) {
      ClassData classes = ClassData();
      classes.id = clas.id;
      classes.creator = clas['creator'];
      classes.description = clas['description'];
      classes.name = clas['name'];

      for (var unit in clas['units'] ?? []) {
        UnitData units = UnitData();
        units.id = unit.id;
        units.name = unit['name'];
        units.description = unit['descirpition'];

        classes.units.add(unit);
      }

      user.classes.add(classes);
    }

    return user;
  }

  static Future<ClassData?> addClass(ClassData clas) async {
    final User fbu = FirebaseAuth.instance.currentUser!;
    final String id = fbu.uid;

    db.collection('classes').doc(clas.id).set({
      'name': clas.name,
      'description': clas.description,
      'dateMade': clas.dateMade,
      'creator': clas.creator,
      'creator_id': id,
      'units': []
    });

    return clas;
  }

  static Future<UserData?> registerUser(UserData user) async {
    final User fbu = FirebaseAuth.instance.currentUser!;
    user.email = fbu.email ?? "";
    user.id = fbu.uid;

    await db.collection('users').doc(user.id).set({
      'firstname': user.firstName,
      'lastname': user.lastName,
      'pfp': user.pfp,
      'classes': user.classes,
      'email': user.email
    });

    return user;
  }

  static Future<List<ClassData>?> getClasses(BuildContext context) async {
    List<ClassData> classes = [];

    final query = await db
        .collection('classes')
        .orderBy("dateMade", descending: true)
        .get();

    for (var doc in query.docs) {
      final data = doc.data();
      List<UnitData> units = [];
      final clas = ClassData();
      clas.creator = data?['creator'];
      clas.dateMade = (data?['dateMade'] as Timestamp).toDate();
      clas.description = data?['description'];
      clas.id = doc.id;
      clas.name = data?['name'];
      for (var unit in data?['units'] ?? []) {
        UnitData units = UnitData();
        units.id = unit.id;
        units.name = unit['name'];
        units.description = unit['descirpition'];

        clas.units.add(unit);
      }
      classes.add(clas);
    }
    return classes;
  }
}
