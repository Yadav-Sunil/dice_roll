import 'package:dice_app/service/authService.dart';
import 'package:dice_app/utils/Images.dart';
import 'package:dice_app/utils/screen_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                              "Sign Up",
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
                                      .setWidth(ScreenUtil.screenWidth / 2),
                                  height: ScreenUtil().setHeight(50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black),
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                              onTap: () async {
                                User user = await signUp(_emailController.text,
                                    _passwordController.text, _scaffoldKey);
                                print('-----------------${user.toString()}');
                                // Navigator.of(context).pushNamedAndRemoveUntil
                                //   (RouteName.Home, (Route<dynamic> route) => false
                                // );
                              }),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Don't have an account? Sign In",
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
                                      .setWidth(ScreenUtil.screenWidth / 2),
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
                                        'Sign Up with Google',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                              onTap: () async {
                                User user =
                                    await signInWithGoogle(_scaffoldKey);
                                print('-----------------${user.toString()}');
                                // Navigator.of(context).pushNamedAndRemoveUntil
                                //   (RouteName.Home, (Route<dynamic> route) => false
                                // );
                              }),
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

  void _signInWithEmailAndPassword() async {
    /*final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = false;
      });
    }*/
  }
}