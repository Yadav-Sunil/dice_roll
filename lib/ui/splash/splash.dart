import 'dart:async';

import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/utils/Images.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      )),
    );
  }
}
