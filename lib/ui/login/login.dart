import 'package:dice_app/service/authService.dart';
import 'package:dice_app/ui/db/database.dart';
import 'package:dice_app/utils/Images.dart';
import 'package:dice_app/utils/routeNames.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Database database = Database();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _userLoginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(250),
                width: ScreenUtil().setHeight(150),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.dice6),
                  ),
                ),
              ),
              Container(
                child: Form(
                  key: _userLoginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 15, left: 10, right: 10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: ScreenUtil().setSp(25),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(15),
                                right: ScreenUtil().setWidth(14),
                                left: ScreenUtil().setWidth(14),
                                bottom: ScreenUtil().setHeight(8)),
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ScreenUtil().setSp(15)),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                hintText: "Email",
                                hintStyle:
                                    TextStyle(fontSize: ScreenUtil().setSp(15)),
                                contentPadding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(15)),
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(15),
                              right: ScreenUtil().setWidth(14),
                              left: ScreenUtil().setWidth(14),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: !passwordVisible,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ScreenUtil().setSp(15)),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                hintText: "Password",
                                contentPadding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(15)),
                                hintStyle:
                                    TextStyle(fontSize: ScreenUtil().setSp(15)),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    }),
                              ),
                              cursorColor: Colors.black,
                            ),
                          ),
                          InkWell(
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                width: ScreenUtil()
                                    .setWidth(ScreenUtil.screenWidth / 1.5),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black),
                                child: Center(
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(16),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                            onTap: () => _sign(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouteName.Register);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                width: ScreenUtil()
                                    .setWidth(ScreenUtil.screenWidth / 1.5),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: ScreenUtil().setHeight(30.0),
                                      width: ScreenUtil().setWidth(30.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(Images.google),
                                            fit: BoxFit.cover),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )),
                            onTap: () => _signInWithGoogle(),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    User user = await signInWithGoogle();
    if (user != null && user.emailVerified) {
      await database
          .storeUserData(userData: user)
          .whenComplete(
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                RouteName.Home, (Route<dynamic> route) => false,
                arguments: user),
          )
          .catchError(
            (e) => print('Error in storing data: $e'),
          );
    } else {
      final snackBar = SnackBar(content: Text('Email not verified'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _sign() async {
    User user = await signIn(
        email: _emailController.text, password: _passwordController.text);
    if (user.emailVerified) {
      await database
          .storeUserData(userData: user)
          .whenComplete(
            () => Navigator.of(context).pushNamedAndRemoveUntil(
            RouteName.Home, (Route<dynamic> route) => false,
            arguments: user),
      )
          .catchError(
            (e) => print('Error in storing data: $e'),
      );
    } else {
      final snackBar = SnackBar(content: Text('Email not verified'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}
