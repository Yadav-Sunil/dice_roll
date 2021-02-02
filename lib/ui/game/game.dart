import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_app/model/diceroll.dart';
import 'package:dice_app/model/user.dart';
import 'package:dice_app/service/authService.dart';
import 'package:dice_app/ui/db/database.dart';
import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/utils/Images.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  UserModel user;

  GameScreen({this.user});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  Database database = Database();

  String peerId;
  String id;
  String groupChatId;
  SharedPreferences prefs;

  @override
  void initState() {
    database.updateUserPresence(presence: true);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    groupChatId = '';
    readLocal();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = widget.user.uid;//prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'payWith': peerId});

    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      database.updateUserPresence(presence: true);
    } else if (state == AppLifecycleState.paused) {
      database.updateUserPresence(presence: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Image.asset(
            Images.dice6,
            width: ScreenUtil.screenWidth / 2,
            height: ScreenUtil.screenWidth / 2,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: database.retrieveRollUsers(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  var doc;// = snapshot.data.docs[0];
                  return RaisedButton(
                    onPressed: () {
                      Random random = new Random();
                      int randomNumber = 1 + random.nextInt(7 - 1);
                      onSendMessage(randomNumber, doc);
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                        alignment: Alignment.center,
                        color: Colors.blue,
                        width: ScreenUtil().setWidth(150),
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Roll',
                            style: TextStyle(fontSize: 20))),
                  );
                }
                return Container();
              }),
          Center(
            child: Text(
              'No User',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void onSendMessage(int randomNumber, docs) {
    var documentReference = FirebaseFirestore.instance
        .collection('diceRoll')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(id);

    DiceRollModel rollData = DiceRollModel(
        userName: userName,
        currentRoll: randomNumber,
        rollCount: docs == null
            ? 0
            : (docs['rollCount'] == 10
            ? 0
            : docs['rollCount'] + 1),
        score: docs == null
            ? 0
            : (docs['rollCount'] == 10
            ? 0
            : docs['score'] + randomNumber),
        isroll: true,
        uid: uid);
    // database.storeRollUserData(userData: rollData);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        rollData.toJson(),
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 40.0,
            height: 40.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("${widget?.user?.imageUrl}"))),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget?.user?.userName}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '${widget?.user?.email}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              signOut();
            },
            child: Icon(
              Icons.logout,
              size: 26.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    bool signout = await googleSignOut();
    if (signout) {
      await database.updateUserPresence(presence: false);
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.USER_LOGIN, (Route<dynamic> route) => false,
          arguments: LoginScreen());
    }
  }

  Future<void> updatePresense() async {
    User user = FirebaseAuth.instance.currentUser;
    await database.storeUserData(userData: user, presence: true);
  }

  void setPairId(AsyncSnapshot<dynamic> snapshot, userSize) async {
    String id = await getPeerUserId();
    if (id.isNotEmpty) {
      Random random = new Random();
      int randomNumber = random.nextInt(userSize);
      var doc = snapshot.data.docs[randomNumber];
      setPeerUserId(doc['uid']);
    }
  }
}
