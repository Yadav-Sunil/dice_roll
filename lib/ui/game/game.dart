import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_app/model/diceroll.dart';
import 'package:dice_app/model/user.dart';
import 'package:dice_app/service/authService.dart';
import 'package:dice_app/ui/db/database.dart';
import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  UserModel user;
  String peerId;

  GameScreen({this.peerId, this.user});

  @override
  GameScreenState createState() => GameScreenState(peerId: peerId, user: user);
}

class GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  Database database = Database();
  UserModel user;
  String peerId;
  String id;
  String groupChatId;
  bool isRolling = false;

  GameScreenState({@required this.peerId, this.user});

  @override
  void initState() {
    groupChatId = '';
    readLocal();
    database.updateUserPresence(presence: true);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  readLocal() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    id = firebaseUser.uid ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'payWith': peerId, 'playing': true});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      database.updateUserPresence(presence: true);
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'payWith': peerId, 'playing': true});
    } else if (state == AppLifecycleState.paused) {
      database.updateUserPresence(presence: false);
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'payWith': '', 'playing': false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(
            stream: groupChatId.isNotEmpty
                ? database.retrieveRollUsers(groupChatId)
                : null,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                var doc = snapshot.data.docs;
                List<DiceRollModel> data = List<DiceRollModel>.from(
                    doc.map((model) => DiceRollModel.fromJson(model.data())));
                var userName = '';
                var currentRoll = 0;
                var rollCount = 0;
                var score = 0;

                // user Second
                var userNameSecond = '';
                var currentRollSecond = 0;
                var rollCountSecond = 0;
                var scoreSecond = 0;
                data.forEach((element) {
                  var uid = element.uid;
                  if (uid == id) {
                    userName = element.userName;
                    currentRoll = element.currentRoll;
                    rollCount = element.rollCount;
                    score = element.score;
                  } else {
                    userNameSecond = element.userName;
                    currentRollSecond = element.currentRoll;
                    rollCountSecond = element.rollCount;
                    scoreSecond = element.score;
                  }
                });
                return Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '$userName',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                  Text(
                                    '$score',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                  (rollCount == 10 &&
                                          (rollCount == rollCountSecond))
                                      ? Text(
                                          '${score < scoreSecond ? "Lose" : (score == scoreSecond ? 'Draw' : "Win")}',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(15),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '$userNameSecond',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                  Text(
                                    '$scoreSecond',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                  (rollCount == 10 &&
                                          (rollCount == rollCountSecond))
                                      ? Text(
                                          '${score > scoreSecond ? "Lose" : (score == scoreSecond ? 'Draw' : "Win")}',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(15),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      currentRoll == 0
                          ? ""
                          : 'assets/images/dice$currentRoll.png',
                      width: ScreenUtil.screenWidth / 2,
                      height: ScreenUtil.screenWidth / 2,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Random random = new Random();
                        int randomNumber = 1 + random.nextInt(7 - 1);
                        if (!isRolling) {
                          if (rollCount >= 9 &&
                              (rollCount == rollCountSecond)) {
                            onResetGame(data);
                          } else if (rollCount >= 0 &&
                                  rollCount <= 9 &&
                                  rollCountSecond >= 0 &&
                                  rollCountSecond <= 9 ||
                              rollCountSecond == 10) {
                            onSendMessage(randomNumber, data);
                          } else {
                            if (rollCount == 10 && rollCountSecond == 0) {
                              onResetGame(data);
                            }
                          }
                        }
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        height: ScreenUtil().setHeight(45),
                        alignment: Alignment.center,
                        color: Colors.blue,
                        width: ScreenUtil().setWidth(150),
                        child: isRolling
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      new AlwaysStoppedAnimation<Color>(
                                    Colors.orange,
                                  ),
                                ),
                              )
                            : Text(
                                rollCount < 10
                                    ? 'Roll'
                                    : ((rollCount >= 10 &&
                                            (rollCount == rollCountSecond))
                                        ? 'Play Again'
                                        : 'Wait'),
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
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
                    image: NetworkImage("${user?.imageUrl}"))),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.userName}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '${user?.email}',
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

  Future<void> onSendMessage(int randomNumber, List<DiceRollModel> data) async {
    setState(() {
      isRolling = true;
    });
    var documentReference = FirebaseFirestore.instance
        .collection('diceRoll')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(id);

    DiceRollModel rollData;
    if (data.length == 0) {
      rollData = DiceRollModel(
          userName: userName,
          currentRoll: 0,
          rollCount: 0,
          score: 0,
          isroll: true,
          uid: id);
      await documentReference.set(rollData.toJson());
      setState(() {
        isRolling = false;
      });
    }
    if (data.length == 1) {
      DiceRollModel element = data[0];
      var uid = element.uid;
      var userName = element.userName;
      var currentRoll = element.currentRoll;
      var rollCount = element.rollCount;
      var score = element.score;
      // if (uid == id) {
      rollData = DiceRollModel(
          userName: userName,
          currentRoll: randomNumber,
          rollCount: rollCount >= 10 ? 0 : rollCount + 1,
          score: rollCount >= 10 ? 0 : score + randomNumber,
          isroll: true,
          uid: id);
      await documentReference.set(rollData.toJson());
      setState(() {
        isRolling = false;
      });
      // }
    } else {
      data.forEach((element) async {
        var uid = element.uid;
        var userName = element.userName;
        var currentRoll = element.currentRoll;
        var rollCount = element.rollCount;
        var score = element.score;
        if (uid == id) {
          rollData = DiceRollModel(
              userName: userName,
              currentRoll: randomNumber,
              rollCount: rollCount >= 10 ? 0 : rollCount + 1,
              score: rollCount >= 10 ? 0 : score + randomNumber,
              isroll: true,
              uid: id);
          await documentReference.set(rollData.toJson());
          setState(() {
            isRolling = false;
          });
        }
      });
    }
  }

  onResetGame(List<DiceRollModel> data) {
    setState(() {
      isRolling = true;
    });

    var documentReference = FirebaseFirestore.instance
        .collection('diceRoll')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(id);

    DiceRollModel rollData;
    data.forEach((element) async {
      var uid = element.uid;
      if (uid == id) {
        var userName = element.userName;
        rollData = DiceRollModel(
          userName: userName,
          currentRoll: 0,
          rollCount: 0,
          score: 0,
          isroll: true,
          uid: uid,
        );
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(
            documentReference,
            rollData.toJson(),
          );
        });
        setState(() {
          isRolling = false;
        });
      }
    });
  }
}
