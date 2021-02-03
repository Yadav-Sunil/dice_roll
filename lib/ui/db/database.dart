import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_app/model/diceroll.dart';
import 'package:dice_app/model/user.dart';
import 'package:dice_app/service/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  /// The main Firestore user collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference diceRollCollection =
      FirebaseFirestore.instance.collection('diceRoll');

  storeUserData({@required User userData, bool presence}) async {
    DocumentReference documentReferencer = userCollection.doc(uid);

    UserModel user = UserModel(
      payWith: '',
      userName: userData?.displayName,
      uid: uid,
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
    prefs.setString('id', userData.uid);

    updateUserPresence(presence: true);
  }

  Stream<QuerySnapshot> retrieveUsers() {
    Stream<QuerySnapshot> queryUsers = userCollection
        // .where('uid', isNotEqualTo: uid)
        .where('presence', isEqualTo: true)
        // .orderBy('last_seen', descending: true)
        .snapshots();

    return queryUsers;
  }

  storeRollUserData({@required DiceRollModel userData}) async {
    var groupChatId;
    String id = await getPeerUserId();
    if (id.hashCode <= uid.hashCode) {
      groupChatId = '$id-$uid';
    } else {
      groupChatId = '$uid-$id';
    }
    DocumentReference documentReferencer =
        diceRollCollection.doc(groupChatId).collection(uid).doc(uid);

    var data = userData.toJson();

    await documentReferencer.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));

    updateUserPresence(presence: true);
  }

  Stream<QuerySnapshot> retrieveRollUsers(String groupChatId) {
    Stream<QuerySnapshot> queryUsers =  FirebaseFirestore.instance
        .collection('diceRoll')
        .doc(groupChatId)
        .collection(groupChatId).snapshots();

   /* Stream<QuerySnapshot> queryUsers = diceRollCollection
        // .where('presence', isEqualTo: true)
        // .orderBy('last_seen', descending: true)
        .snapshots();*/

    return queryUsers;
  }

  updateUserPresence({bool presence}) async {
    Map<String, dynamic> presenceStatusTrue = {
      'presence': presence,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    DocumentReference documentReferencer = userCollection.doc(uid);
    documentReferencer
        .update(presenceStatusTrue)
        .whenComplete(() => print('Updated your presence.'))
        .catchError((e) => print(e));
  }
}
