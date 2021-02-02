import 'package:dice_app/service/authService.dart';
import 'package:dice_app/ui/db/database.dart';
import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  User user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database database = Database();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatePresense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage("${widget?.user?.photoURL}"))),
        ),
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
}
