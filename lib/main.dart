import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app_intern/screens/homeScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:group_chat_app_intern/screens/loginscreen.dart';
import 'package:group_chat_app_intern/widgets/loadingScreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpalshScreen(),
    );
  }
}

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingScreen();
        if (!snapshot.hasData || snapshot.data == null) {
          return LoginPage();
        } else {
          String userId = snapshot.data.uid;

          final FirebaseFirestore _firestore = FirebaseFirestore.instance;
          DocumentReference ref = _firestore.collection('Users').doc(userId);

          ref.get().then((value) {
            if (value.exists) {
              String UserId = value.data()["U"];
              String UserName = value.data()["N"];
              String email = value.data()["E"];
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(UserName, UserId, email)),
                  (route) => false);
            } else {
              FirebaseAuth.instance.signOut();
            }
          });
        }
        return LoadingScreen();
      },
    );
  }
}

class SpalshScreen extends StatefulWidget {
  SpalshScreen({Key key}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  bool _visible = true;
  Timer _timer;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      Duration(milliseconds: 400),
      () => {
        setState(() {
          _visible = false;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(seconds: 1),
                child: CheckLogin(),
              ),
            ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 0.0 : 1.0,
          duration: Duration(seconds: 3),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
            child: Image.asset("assets/chat.png"),
          ),
        ),
      ),
    );
  }
}
