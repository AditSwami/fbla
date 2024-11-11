import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class ClassData {
  ClassData(
      {required this.className,
      required this.classDescription,
      required this.dateMade,
      required this.creator});

  String className;
  String classDescription;
  DateTime dateMade;
  String creator;

  factory ClassData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return ClassData(
        className: data?['name'],
        classDescription: data?['description'],
        dateMade: data?['date_made'],
        creator: data?['creator']);
  }

  void toFirestore() {
    db.collection('classes').add({
      'name': className,
      'creator': creator,
      'description': classDescription,
      'date_made': dateMade
    });
  }
}
