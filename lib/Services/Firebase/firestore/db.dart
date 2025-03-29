import 'dart:io';
import 'dart:convert';

import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
      classes.creator_id = clas['creator_id'];
      classes.description = clas['description'];
      classes.name = clas['name'];
      classes.members = clas['members'];

      for (var unit in clas['units'] ?? []) {
        UnitData units = UnitData();
        units.id = unit.id;
        units.name = unit['name'];
        units.description = unit['descirpition'];
        units.testScore = unit['testScore'];

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
    UserData user = context.read<UserProvider>().getCurrentUser();

    final query = await db
        .collection('classes')
        .orderBy("dateMade", descending: true)
        .where('creator_id', isNotEqualTo: user.id)
        .get();

    for (var doc in query.docs) {
      final data = doc.data();
      final members = data['members'] as List<dynamic>? ?? [];
      
      // Skip if user is already a member
      if (members.contains(user.id)) {
        continue;
      }

      final clas = ClassData();
      clas.creator = data['creator'];
      clas.creator_id = data['creator_id'];
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
          units.testScore = uni['testScore'];

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
      
      // Only process if user is a member and not the creator
      if ((data['members'] ?? []).contains(user.id) && data['creator'] != user.id) {
        final clas = ClassData();
        clas.creator = data['creator'];
        clas.creator_id = data['creator_id'];
        clas.dateMade = (data['dateMade'] as Timestamp).toDate();
        clas.description = data['description'];
        clas.id = doc.id;
        clas.name = data['name'];
        clas.members = data['members'];
        
        if (data['units'] != null) {
          for (var unit in (data['units'] as Map<String, dynamic>).entries) {
            UnitData units = UnitData();
            String unitId = unit.key;
            var uni = unit.value;
            units.id = unitId;
            units.name = uni['name'];
            units.description = uni['description'];
            units.terms = uni['terms'];
            // Add type conversion for testScore
            units.testScore = int.tryParse(uni['testScore']?.toString() ?? '0') ?? 0;

            clas.units[unitId] = units;
          }
        }
        classes.add(clas);
      }
    }
    return classes;
  }

  static Future<List<ClassData>?> getUserCreatedClasses(
      BuildContext context) async {
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
      clas.creator_id = data['creator_id'];
      clas.dateMade = (data['dateMade'] as Timestamp).toDate();
      clas.description = data['description'];
      clas.members = data['members'] ?? [];
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
          units.terms = uni['terms'];
          // Add type conversion for testScore
          units.testScore = int.tryParse(uni['testScore']?.toString() ?? '0') ?? 0;

          clas.units[unitId] = units;
        }
      }
      if (data['creator_id'] == user.id) {
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
      'testScore': unit.testScore,
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
      unitData.terms = value['terms'];
      unitData.testScore = value['testScore'];


      
      return MapEntry(key, unitData);
    });

    for (final entry in unitsMap.entries) {
      var unit = entry.value;
      UnitData uni = UnitData();
      uni.id = entry.key;
      uni.name = unit['name'];
      uni.testScore = unit['testScore'];
      uni.description = unit['description'];
      uni.terms = unit['terms'];


      units.add(uni);
    }

    return units;
  }

  static Future<void> addTerm( Map<String, dynamic> term, UnitData unit, ClassData clas) async {
  final docRef = db.collection('classes').doc(clas.id);
  final docSnap = await docRef.get();
  final data = docSnap.data();
  Map<String, dynamic> existingTerms = data!['units'][unit.id]!['terms'];
  existingTerms.addAll(term);
    await db.collection('classes').doc(clas.id).update({
      'units.${unit.id}.terms': existingTerms
    });
  }

  static Future<void> joinClass(ClassData clas, BuildContext context) async {
    UserData user = context.read<UserProvider>().getCurrentUser();
    
    await db.collection('classes').doc(clas.id).update({
      'members': FieldValue.arrayUnion([user.id])
    });

  }

  static Future<Map<String, dynamic>?> getUnitTerms(String classId, String unitId) async {
    final docRef = await db.collection('classes').doc(classId).get();
    if (!docRef.exists) return null;

    final data = docRef.data();
    if (data == null) return null;

    final units = data['units'] as Map<String, dynamic>?;
    if (units == null) return null;

    final unit = units[unitId];
    if (unit == null) return null;

    return unit['terms'] as Map<String, dynamic>?;
  }

  static Future<void> deleteClass(String classId) async {
      await db.collection('classes').doc(classId).delete();
  }

static Future<void> makePost(PostData post, List<XFile> files, UserData user) async {
  try {
    final docRef = db.collection("posts").doc();
    post.id = docRef.id;
    post.uid = user.id;
    post.user = user;

    List<String> imageList = [];

    // Process and compress images
    for (var file in files) {
      File imageFile = File(file.path);
      if (await imageFile.exists()) {
        final rawImage = img.decodeImage(await imageFile.readAsBytes());
        if (rawImage != null) {
          final compressedImage = img.encodeJpg(rawImage, quality: 70); // Compress image
          final base64Image = base64Encode(compressedImage);
          imageList.add(base64Image);
          post.pics.add(base64Image);
        }
      }
    }

    // Create post with all images at once
    await docRef.set({
      "description": post.description,
      "likes": [],
      "date": post.date,
      "title": post.title,
      "type": post.type,
      "uid": post.uid,
      "pics": imageList,
      "comments": {},
    });

  } catch (e) {
    print("Error creating post: $e");
    rethrow;
  }
}


  static Future<void> deletePost(PostData post) async {
    // No need to delete from storage, just delete from Firestore
    await db.collection("posts").doc(post.id).delete();
  }

  static Future<List<PostData>> getFeedPosts(BuildContext context) async {
    List<PostData> posts = [];

    final querySnap = await db
        .collection("posts")
        .where("uid",
            isNotEqualTo: context.read<UserProvider>().currentUser.id)
        .orderBy("date", descending: true)
        .get();

    for (var doc in querySnap.docs) {
      final data = doc.data();
      final post = PostData();
      post.uid = data['uid'];
      post.pics = List.from(data['pics']); // Now getting base64 strings
      post.description = data['description'];
      post.title = data['title'];
      post.date = data['date'];
      post.type = data['type'];
      post.id = doc.id;
      post.likes = List.from(data['likes']);
      post.user =
          (await context.read<UserProvider>().getUser(post.uid)) ?? UserData();

      List<String> commentIDs = data['comments'].keys.toList();
      for (var cID in commentIDs) {
        CommentData comment = CommentData();
        comment.uid = data['comments'][cID]['uid'];
        comment.content = data['comments'][cID]['content'];
        comment.likes = List.from(data['comments'][cID]['likes']);
        comment.time = data['comments'][cID]['time'];
        comment.id = cID;

        List<String> replyIDs = data['comments'][cID]['replies'].keys.toList();
        for (var rID in replyIDs) {
          ReplyData reply = ReplyData();
          reply.uid = data['comments'][cID]['replies'][rID]['uid'];
          reply.content = data['comments'][cID]['replies'][rID]['content'];
          reply.likes =
              List.from(data['comments'][cID]['replies'][rID]['likes']);
          reply.time = data['comments'][cID]['replies'][rID]['time'];
          reply.id = rID;

          comment.replies.add(reply);
        }

        post.comments.add(comment);
      }

      posts.add(post);
    }

    return posts;
  }

  static Future<List<PostData>> getUserPosts(UserData user) async {
    List<PostData> posts = [];

    final querySnap = await db
        .collection("posts")
        .where("uid", isEqualTo: user.id)
        .orderBy("date", descending: true)
        .get();

    for (var doc in querySnap.docs) {
      final data = doc.data();
      final post = PostData();
      post.uid = user.id;
      post.pics = List.from(data['pics']); // Now getting base64 strings
      post.description = data['description'];
      post.title = data['title'];
      post.date = data['date'];
      post.type = data['type'];
      post.id = doc.id;
      post.likes = List.from(data['likes']);
      post.user = user;

      List<String> commentIDs = data['comments'].keys.toList();
      for (var cID in commentIDs) {
        CommentData comment = CommentData();
        comment.uid = data['comments'][cID]['uid'];
        comment.content = data['comments'][cID]['content'];
        comment.likes = List.from(data['comments'][cID]['likes']);
        comment.time = data['comments'][cID]['time'];
        comment.id = cID;

        List<String> replyIDs = data['comments'][cID]['replies'].keys.toList();
        for (var rID in replyIDs) {
          ReplyData reply = ReplyData();
          reply.uid = data['comments'][cID]['replies'][rID]['uid'];
          reply.content = data['comments'][cID]['replies'][rID]['content'];
          reply.likes =
              List.from(data['comments'][cID]['replies'][rID]['likes']);
          reply.time = data['comments'][cID]['replies'][rID]['time'];
          reply.id = rID;

          comment.replies.add(reply);
        }

        post.comments.add(comment);
      }

      posts.add(post);
    };
    return posts;
  }

  static Future<void> likePost(PostData post, BuildContext context) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);

    await docRef.set({
      "likes":
          FieldValue.arrayUnion([context.read<UserProvider>().currentUser.id])
    }, SetOptions(merge: true));
  }

  static Future<void> unLikePost(PostData post, BuildContext context) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);

    await docRef.set({
      "likes":
          FieldValue.arrayRemove([context.read<UserProvider>().currentUser.id])
    }, SetOptions(merge: true));
  }

  static Future<List<CommentData>> getComments(PostData post) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);
    DocumentSnapshot docSnap = await docRef.get();
    if (!docSnap.exists) {
      return post.comments;
    }

    final List<CommentData> comments = [];

    final Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

    List<String> commentIDs = data['comments'].keys.toList();
    for (var cID in commentIDs) {
      CommentData comment = CommentData();
      comment.uid = data['comments'][cID]['uid'];
      comment.content = data['comments'][cID]['content'];
      comment.likes = List.from(data['comments'][cID]['likes']);
      comment.time = data['comments'][cID]['time'];
      comment.id = cID;

      List<String> replyIDs = data['comments'][cID]['replies'].keys.toList();
      for (var rID in replyIDs) {
        ReplyData reply = ReplyData();
        reply.uid = data['comments'][cID]['replies'][rID]['uid'];
        reply.content = data['comments'][cID]['replies'][rID]['content'];
        reply.likes = List.from(data['comments'][cID]['replies'][rID]['likes']);
        reply.time = data['comments'][cID]['replies'][rID]['time'];
        reply.id = rID;

        comment.replies.add(reply);
      }

      comments.add(comment);
    }

    return comments;
  }

  static Future<void> addComment(CommentData comment, PostData post) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);
    await docRef.set({
      "comments": {
        comment.id: {
          "content": comment.content,
          "likes": [],
          "time": comment.time,
          "uid": comment.uid,
          "replies": {},
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> deleteComment(CommentData comment, PostData post) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);
    await docRef.set({
      "comments": {comment.id: FieldValue.delete()}
    }, SetOptions(merge: true));
  }

  static Future<void> likeComment(
      CommentData comment, PostData post, BuildContext context) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);

    await docRef.set({
      "comments": {
        comment.id: {
          "likes": FieldValue.arrayUnion(
              [context.read<UserProvider>().currentUser.id])
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> unLikeComment(
      CommentData comment, PostData post, BuildContext context) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);

    await docRef.set({
      "comments": {
        comment.id: {
          "likes": FieldValue.arrayRemove(
              [context.read<UserProvider>().currentUser.id])
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> addReply(
      ReplyData reply, CommentData comment, PostData post) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);
    await docRef.set({
      "comments": {
        comment.id: {
          "replies": {
            reply.id: {
              "content": reply.content,
              "likes": reply.likes,
              "time": reply.time,
              "uid": reply.uid,
            }
          }
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> deleteReply(
      ReplyData reply, CommentData comment, PostData post) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);
    await docRef.set({
      "comments": {
        comment.id: {
          "replies": {reply.id: FieldValue.delete()}
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> likeReply(ReplyData reply, CommentData comment,
      PostData post, BuildContext context) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);

    await docRef.set({
      "comments": {
        comment.id: {
          "replies": {
            reply.id: {
              "likes": FieldValue.arrayUnion(
                  [context.read<UserProvider>().currentUser.id])
            }
          }
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> unLikeReply(ReplyData reply, CommentData comment,
      PostData post, BuildContext context) async {
    DocumentReference docRef = db.collection("posts").doc(post.id);

    await docRef.set({
      "comments": {
        comment.id: {
          "replies": {
            reply.id: {
              "likes": FieldValue.arrayRemove(
                  [context.read<UserProvider>().currentUser.id])
            }
          }
        }
      }
    }, SetOptions(merge: true));
  }

  static Future<void> updateUnitTestScore(int score, UnitData unit, ClassData clas) async {
    final docRef = db.collection('classes').doc(clas.id);
    
    await docRef.update({
      'units.${unit.id}.testScore': score
    });
  }
}
