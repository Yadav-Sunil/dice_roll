import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_app/model/user.dart';
import 'package:dice_app/service/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  /// The main Firestore user collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  storeUserData({@required User userData, bool presence}) async {
    DocumentReference documentReferencer = userCollection.doc(uid);

    UserModel user = UserModel(
      userName: userData?.displayName,
      uid: uid,
      name: userName,
      email: userData?.email,
      imageUrl: userData?.photoURL,
      presence: presence,
      lastSeenInEpoch: DateTime.now().millisecondsSinceEpoch,
    );

    var data = user.toJson();

    await documentReferencer.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', userName);

    updateUserPresence(presence: true);
  }

  Stream<QuerySnapshot> retrieveUsers() {
    Stream<QuerySnapshot> queryUsers = userCollection
        // .where('uid', isNotEqualTo: uid)
        .orderBy('last_seen', descending: true)
        .snapshots();

    return queryUsers;
  }

  updateUserPresence({bool presence}) async {
    Map<String, dynamic> presenceStatusTrue = {
      'presence': presence,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    await databaseReference
        .child(uid)
        .update(presenceStatusTrue)
        .whenComplete(() => print('Updated your presence.'))
        .catchError((e) => print(e));

    Map<String, dynamic> presenceStatusFalse = {
      'presence': presence,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };
    presence?
    await databaseReference.child(uid).update(presenceStatusTrue):
    await databaseReference.child(uid).onDisconnect().update(presenceStatusFalse) ;
  }
}
