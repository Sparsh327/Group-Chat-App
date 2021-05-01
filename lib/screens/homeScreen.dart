import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app_intern/models/messageModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:group_chat_app_intern/screens/loginscreen.dart';
import 'package:group_chat_app_intern/widgets/chatBubble.dart';

enum MessageType {
  Sender,
  Receiver,
}

class HomeScreen extends StatefulWidget {
  // HomeScreen({Key key}) : super(key: key);
  String userName, userId, email;
  HomeScreen(this.userName, this.userId, this.email);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final messageCollection = FirebaseFirestore.instance.collection("Chat");
  TextEditingController textEditingController = new TextEditingController();
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 1),
      () => controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
        backgroundColor: Colors.indigo,
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.white, //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.indigo[900], Colors.indigo[700]])),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                    Colors.indigo[900],
                    Colors.indigo[400]
                  ])),
                  accountName: Text(widget.userName),
                  accountEmail: Text(widget.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      '${widget.userName[0]}',
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                CustomList(Icons.rate_review_outlined, "About Us",
                    () => {Navigator.pop(context)}),
                CustomList(
                    Icons.logout,
                    "LogOut",
                    () => {
                          auth.signOut().whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          })
                        }),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 100),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Chat')
                    .orderBy("TimeStamp")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  print("Length -- " + snapshot.data.docs.length.toString());

                  // return Container(
                  //
                  // );
                  return ListView.builder(
                    controller: controller,
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print("Uid -- " +
                      //     snapshot.data.docs[index].data()['senderUid']);
                      if (widget.userId ==
                          snapshot.data.docs[index].data()['Uid']) {
                        print("Sender");
                      } else {
                        print("Reciever");
                      }

                      return ChatBubble(
                        chatMessage: Message(
                            message:
                                snapshot.data.docs[index].data()['Message'],
                            userName: snapshot.data.docs[index].data()['Name'],
                            uid: snapshot.data.docs[index].data()['Uid'],
                            type: snapshot.data.docs[index].data()['Uid'] ==
                                    widget.userId
                                ? MessageType.Sender
                                : MessageType.Receiver),
                      );
                    },
                  );
                }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.grey[200],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Start Chatting...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                      controller: textEditingController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 30, bottom: 10),
              child: FloatingActionButton(
                onPressed: () {
                  sendMessage(textEditingController.text.trim(), widget.userId,
                      widget.userName);
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                backgroundColor: Colors.indigo,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String message, String uid, String userName) {
    // print("Uid - " + Uid);
    // print("Name - " + UName);

    db.collection("Chat").add({
      "Message": message,
      "Uid": uid,
      "Name": userName,
      "TimeStamp": Timestamp.now()
    });

    textEditingController.clear();

    Timer(
      Duration(seconds: 1),
      () => controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }
}

class CustomList extends StatelessWidget {
  IconData icon;
  String text;
  Function OnTap;

  CustomList(this.icon, this.text, this.OnTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.indigo,
        onTap: OnTap,
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, color: Colors.white),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
