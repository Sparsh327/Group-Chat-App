import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:group_chat_app_intern/screens/homeScreen.dart';

class Message {
  String message, userName, uid;
  MessageType type;
  Timestamp time;
  Message(
      {@required this.message,
      @required this.userName,
      @required this.uid,
      @required this.type});
}
