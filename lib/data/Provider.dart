import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class UserProvider with ChangeNotifier {
  UserData _currentUser = UserData();
  bool _isAuth = false;
  List<ClassData> _classes = [];
  final List<UserData> _users = [];
  List<PostData> _posts = [];
  List<PostData> _userPosts = [];

  UserData get currentUser => _currentUser;
  bool get isAuth => _isAuth;
  List<ClassData> get classes => _classes;
  List<UserData> get users => _users;
  List<PostData> get posts => _posts;
  List<PostData> get userPosts => _userPosts;

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

  Future<List<ClassData>?> getClasses(BuildContext context) async {
    if (classes.isNotEmpty) {
      return classes;
    } else {
      _classes = (await Firestore.getClasses(context))!;
      return classes;
    }
  }

  void setAuth(bool isAuthenticated) {
    _isAuth = isAuthenticated;
    notifyListeners();
  }

  void addClass(ClassData clas) async {
    if (classes.indexWhere((e) => e.id == clas.id) < 0) {
      await Firestore.addClass(clas);
      classes.add(clas);
    }
    notifyListeners();
  }

  Future<void> joinClass(ClassData classData, BuildContext context) async {
    // First check if already a member
    if (!_currentUser.classes.any((clas) => clas?.id == classData.id)) {
      // Only add if not already a member
      _currentUser.classes.add(classData);
      notifyListeners();
      // Update Firestore
      await Firestore.joinClass(classData, context);
    }
  }

  // Add this method to sync with Firestore
  Future<void> loadJoinedClasses(BuildContext context) async {
    final joinedClasses = await Firestore.getUserClasses(context);
    if (joinedClasses != null) {
      _currentUser.classes = joinedClasses.map((c) => c).toList();
      notifyListeners();
    }
  }

  bool isClassMember(String classId) {
    return _currentUser.classes.any((clas) => clas?.id == classId);
  }

  void removeClass(ClassData clas) async{
      await Firestore.deleteClass(clas.id);
      _classes.removeWhere((c) => c.id == clas.id);
      notifyListeners();
  }

  Future<List<PostData>> loadPosts(BuildContext context) async{
    _posts = await Firestore.getFeedPosts(context);
    _userPosts = await Firestore.getUserPosts(currentUser);
    for(var post in _userPosts){
      _posts.add(post);
    }
    return _posts;
  }

  List<PostData> getPosts(){
    return posts;
  }

  Future<List<PostData>> loadUserPosts(BuildContext context) async{
    _userPosts = await Firestore.getUserPosts(currentUser);
    return _posts;
  }

  List<PostData> getUserPosts(){
    return userPosts;
  }

  void addPost(PostData post, List<XFile> images) async {
    await Firestore.makePost(post, images, currentUser);
    _posts.add(post);
    notifyListeners();
  }
}
