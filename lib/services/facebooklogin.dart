import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:group_chat_app_intern/main.dart';

class AuthProvider {
  final db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  FacebookLogin facebookLogin = FacebookLogin();
  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);

    User _user = a.user;
    print(_user);

    uploadData(_user);
  }

  uploadData(User _user) {
    db.collection("Users").doc(_user.uid).set({
      "N": _user.displayName,
      "U": _user.uid,
      "E": _user.email,
    });
  }
}
 // Future<void> gooleSignout() async {
  //   await _auth.signOut().then((onValue) {
  //     setState(() {
  //       facebookLogin.logOut();
  //       isSignIn = false;
  //     });
  //   });
  // }