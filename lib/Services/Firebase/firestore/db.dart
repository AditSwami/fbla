import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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

        classes.units[unit.id] = unit;
      }

      user.classes.add(classes);
    }

    return user;
  }

  static Future<ClassData?> addClass(ClassData clas) async {
    final User fbu = FirebaseAuth.instance.currentUser!;
    final String id = fbu.uid;

    Map<String, dynamic> units = {};

    db.collection('classes').doc(clas.id).set({
      'name': clas.name,
      'description': clas.description,
      'dateMade': clas.dateMade,
      'creator': clas.creator,
      'creator_id': id,
      'units': units
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
      // ignore: unused_local_variable
      List<UnitData> units = [];
      final clas = ClassData();
      clas.creator = data['creator'];
      clas.dateMade = (data['dateMade'] as Timestamp).toDate();
      clas.description = data['description'];
      clas.id = doc.id;
      clas.name = data['name'];
      if(data['units'] != null){
        for (var unit in (data['units'] as Map<String, dynamic>).entries) {
          UnitData units = UnitData();
          String unitId = unit.key;
          var uni = unit.value;
          units.id = unitId;
          units.name = uni['name'];
          units.description = uni['description'];

          clas.units[unitId] = units;
        }
      }
      classes.add(clas);
    }
    return classes;
  }

  static Future<List<ClassData>?> getUserClasses(BuildContext context) async {
    List<ClassData> classes = [];
    UserData user = context.read<UserProvider>().getCurrentUser();

    final query = await db
        .collection('classes')
        .orderBy("dateMade", descending: true)
        .get();

    for (var doc in query.docs) {
      final data = doc.data();
      // ignore: unused_local_variable
      List<UnitData> units = [];
      final clas = ClassData();
      for(var member in data?['members'] ?? []){
        if(member == user.id) {
          clas.creator = data['creator'];
          clas.dateMade = (data['dateMade'] as Timestamp).toDate();
          clas.description = data['description'];
          clas.id = doc.id;
          clas.name = data['name'];
          if (data['units'] != null) {
            for (var unit in (data['units'] as Map<String, dynamic>).entries) {
              UnitData units = UnitData();
              String unitId = unit.key;
              var uni = unit.value;
              units.id = unitId;
              units.name = uni['name'];
              units.description = uni['description'];

              clas.units[unitId] = units;
            }
          }
        }
      }
      classes.add(clas);
    }
    return classes;
  }

  static Future<List<ClassData>?> getUserCreatedClasses (BuildContext context) async {
    List<ClassData> classes = [];
    UserData user = context.read<UserProvider>().getCurrentUser();

    final query = await db
        .collection('classes')
        .orderBy("dateMade", descending: true)
        .get();

    for (var doc in query.docs) {
      final data = doc.data();
      // ignore: unused_local_variable
      List<UnitData> units = [];
      final clas = ClassData();
          clas.creator = data['creator'];
          clas.dateMade = (data['dateMade'] as Timestamp).toDate();
          clas.description = data['description'];
          clas.id = doc.id;
          clas.name = data['name'];
          if (data['units'] != null) {
            for (var unit in (data['units'] as Map<String, dynamic>).entries) {
              UnitData units = UnitData();
              String unitId = unit.key;
              var uni = unit.value;
              units.id = unitId;
              units.name = uni['name'];
              units.description = uni['description'];

              clas.units[unitId] = units;
            }
          } 
      if(data['creator'] == user.id){
        classes.add(clas);
      }
    }
    return classes;
  }
  
  static Future<void> addUnit(UnitData unit, ClassData clas) async {
    Map<String, dynamic> terms = {};
    Map<String, dynamic> unitMap = {
      'id': unit.id,
      'name': unit.name,
      'description': unit.description,
      'terms': terms,
    };

    // Use the field path to store the map correctly
    await db.collection('classes').doc(clas.id).set({
      'units': {unit.id: unitMap}
    }, SetOptions(merge: true));
  }

  static Future<List<UnitData?>?> getUnits(BuildContext context, ClassData clas,
      [DocumentSnapshot<Map<String, dynamic>>? snap]) async {
    final docRef = db.collection('classes').doc(clas.id);
    final docSnap = snap ?? await docRef.get();

    List<UnitData?> units = [];

    if (!docSnap.exists) {
      return null;
    }

    final data = docSnap.data();
    final unitsMap = data?['units'] as Map<String, dynamic>?;

    if (unitsMap == null) {
      return null;
    }

    // Convert the Firestore map into Map<String, UnitData>
    unitsMap.map((key, value) {
      final unitData = UnitData();
      unitData.id = value['id'];
      unitData.name = value['name'];
      unitData.description = value['description'];
      final termsMap = value['terms'] as Map<String, dynamic>?;

      if (termsMap != null) {
        unitData.terms = termsMap.map((termKey, termValue) {
          final termData = TermData();
          termData.termName = termValue['termName'];
          termData.defName = termValue['defName'];
          termData.termDataId = termValue['termDataId'];
          return MapEntry(termData, termValue);
        });
      }

      return MapEntry(key, unitData);
    });

    for (final entry in unitsMap.entries) {
      var unit = entry.value;
      UnitData uni = UnitData();
      uni.id = entry.key;
      uni.name = unit['name'];
      uni.description = unit['description'];
      units.add(uni);
    }

    return units;
  }
}
