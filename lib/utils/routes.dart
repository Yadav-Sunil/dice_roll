import 'package:dice_app/ui/home/home.dart';
import 'package:dice_app/ui/login/login.dart';
import 'package:dice_app/ui/register/register.dart';
import 'package:dice_app/ui/splash/splash.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Splash());
      case RouteName.USER_LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteName.Register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RouteName.Home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${settings.name} does not exists!",
                    style: TextStyle(fontSize: ScreenUtil().setHeight(24)),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }
}
