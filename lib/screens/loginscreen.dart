import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app_intern/constants.dart';
import 'package:group_chat_app_intern/main.dart';
import 'package:group_chat_app_intern/screens/signUpScreen.dart';
import 'package:group_chat_app_intern/services/facebooklogin.dart';
import 'package:group_chat_app_intern/widgets/button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();

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

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: textEditingController1,
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
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: textEditingController2,
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

  Widget _buildOrRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            '- Or -',
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            'Login with facebook',
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            await AuthProvider().handleLogin().then((value) {
              print("Profile Created ");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CheckLogin()),
                  (route) => false);
            });
          },
          child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0)
                ],
              ),
              child: Image.asset("assets/facebook.png")),
        )
      ],
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
                      "Login",
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
                  child: _buildEmailRow(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildPasswordRow(),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildTextWithIcon(),
                ),
                _buildOrRow(),
                _buildSocialBtnRow(),
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
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Dont have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Sign Up',
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
            text: 'LOGIN',
            icon: Icon(Icons.login, color: Colors.indigo),
            color: Colors.white,
          ),
          ButtonState.loading: IconedButton(
            text: "Loading",
            color: Colors.deepPurple.shade700,
          ),
          ButtonState.fail: IconedButton(
              text: "Invalid",
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
            textEditingController2.text.isNotEmpty) {
          setState(() {
            stateTextWithIcon = ButtonState.loading;
          });

          try {
            dynamic result = await _auth
                .signInWithEmailAndPassword(
                    email: textEditingController1.text.trim(),
                    password: textEditingController2.text)
                .whenComplete(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CheckLogin()),
                  (route) => false);
            });

            print(" V --- " + result.toString());
          } catch (error) {
            switch (error.code) {
              case "ERROR_INVALID_EMAIL":
                // Toast.show(
                //     "Your email address appears to be malformed.", context);

                print("Your email address appears to be malformed.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_WRONG_PASSWORD":
                // Toast.show("Your password is wrong.", context);

                print("Your password is wrong.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_NOT_FOUND":
                // Toast.show("User with this email doesn't exist.", context);

                print("User with this email doesn't exist.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_DISABLED":
                // Toast.show("User with this email has been disabled.", context);

                print("User with this email has been disabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_TOO_MANY_REQUESTS":
                // Toast.show("Too many requests. Try again later.", context);

                print("Too many requests. Try again later.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_OPERATION_NOT_ALLOWED":
                // Toast.show("Signing in with Email and Password is not enabled.",
                //     context);

                print("Signing in with Email and Password is not enabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              default:
                // Toast.show("An undefined Error happened.", context);

                print("An undefined Error happened.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
            }
          }
        } else {
          print("Please Enter Email & Pass");
        }

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        break;
      case ButtonState.fail:
        setState(() {
          stateTextWithIcon = ButtonState.idle;
        });
        break;
    }
    setState(() {
      stateTextWithIcon = stateTextWithIcon;
    });
  }
}
