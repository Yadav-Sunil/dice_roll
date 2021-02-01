import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User> signUp(email, password,GlobalKey<ScaffoldState> scaffoldKey) async {
  try {
    UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = authResult.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    return user;
  } catch (e) {
    handleError(e, scaffoldKey);
    return null;
  }
}

Future<User> signIn(String email, String password, GlobalKey<ScaffoldState> scaffoldKey) async {
  try {
    UserCredential authResult =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = authResult.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    final User currentUser = await auth.currentUser;
    assert(user.uid == currentUser.uid);
    return user;
  } catch (e) {
    handleError(e, scaffoldKey);
    return null;
  }
}

Future<User> signInWithGoogle(GlobalKey<ScaffoldState> scaffoldKey) async {
  User currentUser;
  try {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential authResult =
        await auth.signInWithCredential(credential);
    final User user = authResult.user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    currentUser = await auth.currentUser;
    assert(user.uid == currentUser.uid);
    print(currentUser.toString());
    return currentUser;
  } catch (e) {
    handleError(e, scaffoldKey);
    return currentUser;
  }
}

void handleError(e, GlobalKey<ScaffoldState> scaffoldKey) {
  final snackBar = SnackBar(content: Text('$e'));
  scaffoldKey.currentState.showSnackBar(snackBar);
  print("Error : $e");
}

Future<bool> googleSignout() async {
  await auth.signOut();
  await googleSignIn.signOut();
  return true;
}
