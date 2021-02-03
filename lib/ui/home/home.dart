import 'dart:async';
import 'dart:math';

import 'package:dice_app/model/user.dart';
import 'package:dice_app/service/authService.dart';
import 'package:dice_app/ui/db/database.dart';
import 'package:dice_app/ui/game/game.dart';
import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  User user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Database database = Database();
  Timer timer;

  @override
  void initState() {
    database.updateUserPresence(presence: true);
    timer = Timer.periodic(Duration(seconds: 5), (timer){
      database.retrieveUsers();
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      database.updateUserPresence(presence: true);
      timer = Timer.periodic(Duration(seconds: 5), (timer){
        database.retrieveUsers();
      });
    } else if (state == AppLifecycleState.paused) {
      database.updateUserPresence(presence: false);
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder(
        stream: database.retrieveUsers(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (_, index) {
                UserModel userData =
                    UserModel.fromJson(snapshot.data.docs[index].data());
                DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(
                    userData.lastSeenInEpoch);
                DateTime currentDateTime = DateTime.now();

                Duration differenceDuration =
                    currentDateTime.difference(lastSeen);
                String durationString = differenceDuration.inSeconds > 59
                    ? differenceDuration.inMinutes > 59
                        ? differenceDuration.inHours > 23
                            ? '${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day' : 'days'}'
                            : '${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'hour' : 'hours'}'
                        : '${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute' : 'minutes'}'
                    : 'few moments';

                String presenceString =
                    userData.presence ? 'Online' : '$durationString ago';

                return userData.uid == uid
                    ? Container()
                    :
                    ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(user: userData),
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  leading: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage("${userData?.imageUrl}"))),
                  ),
                  title: Text(
                    "${userData?.userName}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                  subtitle: Text(
                    "${userData?.email}",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(14),
                    ),
                  ),
                  trailing: Text(
                    presenceString,
                    style: TextStyle(
                      color: userData.presence
                          ? Colors.greenAccent[400]
                          : Colors.grey.withOpacity(0.4),
                      fontSize: ScreenUtil().setSp(14),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 8),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text(
                'No User Found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            ),
          );
        },
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
                    image: NetworkImage("${widget?.user?.photoURL}"))),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget?.user?.displayName}',
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
