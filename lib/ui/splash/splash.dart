import 'dart:async';

import 'package:dice_app/service/authService.dart';
import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/utils/Images.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigateUser);
  }

  void navigateUser() async {
    User user = FirebaseAuth.instance.currentUser;
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.Home, (Route<dynamic> route) => false,
          arguments: user);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.USER_LOGIN, (Route<dynamic> route) => false,
          arguments: LoginScreen());
    }
  }

  Future getUserInfo() async {
    await getUser();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        allowFontScaling: true);
    return Scaffold(
      body: Center(
        child: Image.asset(
          Images.dice6,
          width: ScreenUtil.screenWidth / 2,
          height: ScreenUtil.screenWidth / 2,
        ),
      ),
    );
  }
}
