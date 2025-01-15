import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    db.collection('classes').doc(clas.id).set({
      'name': clas.name,
      'description': clas.description,
      'dateMade': clas.dateMade,
      'units': clas.units,
      'creator': clas.creator,
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
}
