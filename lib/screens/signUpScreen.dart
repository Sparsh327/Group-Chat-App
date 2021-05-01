import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app_intern/constants.dart';
import 'package:group_chat_app_intern/screens/homeScreen.dart';
import 'package:group_chat_app_intern/screens/loginscreen.dart';
import 'package:group_chat_app_intern/widgets/button.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email, password;
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  TextEditingController textEditingController3 = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Row(
            children: [
              Image.asset("assets/chat.png", height: 80),
              SizedBox(width: 10),
              Text(
                'Group Chat App',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNameRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: textEditingController1,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: mainColor,
            ),
            labelText: 'Name'),
      ),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: textEditingController2,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: mainColor,
            ),
            labelText: 'E-mail'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        controller: textEditingController3,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: mainColor,
          ),
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SignUp",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildNameRow(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildEmailRow(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildPasswordRow(),
                ),
                SizedBox(height: 10),
                buildTextWithIcon(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (LoginPage())));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'alredy have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Login',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f3f7),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(70),
                  bottomRight: const Radius.circular(70),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),
              _buildContainer(),
              _buildSignUpBtn(),
            ],
          )
        ],
      ),
    );
  }

  ButtonState stateTextWithIcon = ButtonState.idle;

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
        iconedButtons: {
          ButtonState.idle: IconedButton(
            text: 'SIGN UP',
            icon: Icon(Icons.login, color: Colors.indigo),
            color: Colors.white,
          ),
          ButtonState.loading: IconedButton(
            text: "Loading",
            color: Colors.deepPurple.shade700,
          ),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: Icon(Icons.cancel, color: Colors.white),
              color: Colors.red),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        },
        onPressed: onPressedIconWithText,
        textStyle1: TextStyle(color: Colors.indigo),
        textStyle2: TextStyle(color: Colors.white),
        textStyle3: TextStyle(color: Colors.white),
        state: stateTextWithIcon);
  }

  void onPressedIconWithText() async {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        if (textEditingController1.text.isNotEmpty &&
            textEditingController2.text.isNotEmpty &&
            textEditingController3.text.isNotEmpty) {
          setState(() {
            stateTextWithIcon = ButtonState.loading;
          });

          try {
            dynamic result = await _auth.createUserWithEmailAndPassword(
                email: textEditingController2.text.trim(),
                password: textEditingController3.text);

            if (result == null) {
              // Toast.show("Email Id could not be created", context);
            } else {
              String re = result.toString();
              print('Uid =====> $re');

              final FirebaseAuth _auth = FirebaseAuth.instance;
              User user = await _auth.currentUser;

              if (user != null) {
                db.collection("Users").doc(user.uid).set({
                  "E": textEditingController2.text.trim(),
                  "N": textEditingController1.text.trim(),
                  "U": user.uid
                }).then((value) {
                  // Toast.show("Profile Created ", context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                              textEditingController1.text.trim(),
                              user.uid,
                              textEditingController2.text.trim())),
                      (route) => false);
                });
              }
            }

            print(" V --- " + result.toString());
          } catch (error) {
            switch (error.code) {
              case "ERROR_INVALID_EMAIL":
                print("Your email address appears to be malformed.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_WRONG_PASSWORD":
                print("Your password is wrong.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_NOT_FOUND":
                print("User with this email doesn't exist.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_DISABLED":
                print("User with this email has been disabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_TOO_MANY_REQUESTS":
                print("Too many requests. Try again later.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_OPERATION_NOT_ALLOWED":
                print("Signing in with Email and Password is not enabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              default:
                print("An undefined Error happened.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
            }
          }
        } else {
          print("Please Enter Username, Email & Pass ");
        }

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIcon = stateTextWithIcon;
    });
  }
}
