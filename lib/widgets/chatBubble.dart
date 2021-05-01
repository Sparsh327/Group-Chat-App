import 'package:flutter/material.dart';
import 'package:group_chat_app_intern/models/messageModel.dart';
import 'package:group_chat_app_intern/screens/homeScreen.dart';

class ChatBubble extends StatefulWidget {
  Message chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver
            ? Alignment.topLeft
            : Alignment.topRight),
        child: widget.chatMessage.type == MessageType.Receiver
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: (widget.chatMessage.type == MessageType.Receiver
                      ? Colors.grey[400]
                      : Colors.grey[300]),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.chatMessage.message),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.chatMessage.userName,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: (widget.chatMessage.type == MessageType.Receiver
                      ? Colors.white
                      : Colors.grey.shade200),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.chatMessage.message),
                  ],
                ),
              ),
      ),
    );
  }
}
