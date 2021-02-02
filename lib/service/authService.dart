import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

bool authSignedIn;
String userName;
String uid;
String name;
String email;
String imageUrl;

Future getUser() async {
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  authSignedIn = prefs.getBool('auth') ?? false;

  final User user = auth.currentUser;

  if (authSignedIn == true) {
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      userName = prefs.getString('user_name');
    }
  }
}

Future<User> signUp(
    email, password, GlobalKey<ScaffoldState> scaffoldKey) async {
  await Firebase.initializeApp();
  User currentUser;
  UserCredential authResult = await auth.createUserWithEmailAndPassword(
      email: email, password: password);
  final User user = authResult.user;
  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    authSignedIn = true;

    print('signInWithGoogle succeeded: $user');

    return currentUser;
  }
  return currentUser;
}

Future<User> signIn({
  String email,
  String password,
}) async {
  await Firebase.initializeApp();
  User currentUser;
  UserCredential authResult =
      await auth.signInWithEmailAndPassword(email: email, password: password);
  final User user = authResult.user;

  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    // assert(user.displayName != null);
    // assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName??"";
    email = user.email;
    imageUrl = user.photoURL??"";

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    authSignedIn = true;

    print('signInWithGoogle succeeded: $user');

    return currentUser;
  }
  return currentUser;
}

Future<User> signInWithGoogle() async {
  await Firebase.initializeApp();
  User currentUser;

  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final UserCredential authResult = await auth.signInWithCredential(credential);
  final User user = authResult.user;
  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    authSignedIn = true;

    print('signInWithGoogle succeeded: $user');

    return currentUser;
  }
  return currentUser;
}

Future<bool> googleSignOut() async {
  await auth.signOut();
  await googleSignIn.signOut();
  return true;
}
