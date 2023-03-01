import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zippchatapp/constants/constants.dart';
import '../../constants/colors.dart';
import '../../models/message_model.dart';

class MessageCard extends StatelessWidget {

  final MessageModel messageModel;
  final String currentUser;

  const MessageCard({Key? key,required this.messageModel,required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Timestamp timestamp = messageModel.sent;

    DateTime time = timestamp.toDate();

    if(currentUser!=messageModel.fromUid){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(20),
                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(messageModel.message,style: messageStyle,),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
                child: Text("${time.hour}:${time.minute}")
            ),
          ],
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(0),
                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(messageModel.message,style: messageStyle,),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text("${time.hour}:${time.minute}")
            ),
          ],
        ),
      );
    }
  }
}
