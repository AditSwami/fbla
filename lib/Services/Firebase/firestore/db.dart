import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';

class Firestore {
  static final db = FirebaseFirestore.instance;

  static Future<UserData?> getUser(String uid,
      [DocumentSnapshot<Map<String, dynamic>>? snap]) async {
    UserData user = UserData();

    final docRef = db.collection('users').doc(uid);
    final docSnap = snap ?? await docRef.get();

    var data = docSnap.data();

    user.firstName = data?['firstName'];
    user.lastName = data?['lastName'];
    user.email = data?['email'];
    user.pfp = data?['pfp'];

    for (var clas in data?['classes']) {
      ClassData classes = ClassData();
      classes.id = clas.id;
      classes.creator = clas['creator'];
      classes.description = clas['description'];
      classes.name = clas['name'];

      for (var unit in clas['units']) {
        UnitData units = UnitData();
        units.id = unit.id;
        units.name = unit['name'];
        units.description = unit['descirpition'];

        classes.units.add(units);
      }

      user.classes.add(classes);
    }

    return user;
  }

  static Future<ClassData?> addClass(ClassData clas) async {
    final docRef = db.collection('classes').doc(clas.id).set({
      'name': clas.name,
      'description': clas.description,
      'dateMade': clas.dateMade,
      'units': clas.units,
      'creator': clas.creator,
    });

    return clas;
  }

  
}
