import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  UserData _currentUser = UserData();
  bool _isAuth = false;
  List<ClassData> _classes = [];
  List<UnitData> _units = [];
  List<UserData> _users = [];

  UserData get currentUser => _currentUser;
  bool get isAuth => _isAuth;
  List<ClassData> get classes => _classes;
  List<UnitData> get units => _units;
  List<UserData> get users => _users;

  void setCurentUser(UserData user) {
    _currentUser = user;
    notifyListeners();
  }

  UserData getCurrentUser() {
    return _currentUser;
  }

  Future<UserData?> getUser(String id,
      [DocumentSnapshot<Map<String, dynamic>>? snap]) async {
    if (id == _currentUser.id) {
      return _currentUser;
    }
    int index = users.indexWhere((e) => e.id == id);
    if (index > -1) {
      return users[index];
    } else {
      UserData? user = await Firestore.getUser(id, snap);
      if (user != null) {
        users.add(user);
      }
      return user;
    }
  }

  void setAuth(bool isAuthenticated) {
    _isAuth = isAuthenticated;
    notifyListeners();
  }

  void addClass(ClassData clas) {
    if (classes.indexWhere((e) => e.id == clas.id) < 0) {
      classes.add(clas);
    }
    notifyListeners();
  }
}
