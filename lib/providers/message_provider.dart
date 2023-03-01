import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:zippchatapp/models/user_model.dart';
import '../models/message_model.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String time = DateTime.now().millisecondsSinceEpoch.toString();


  String getConversationId(String id){
    return _auth.currentUser!.uid.hashCode <= id.hashCode ? '${_auth.currentUser!.uid}_$id' : '${id}_${_auth.currentUser!.uid}';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages({required UserModel userModel}) {
    return _fireStore.collection('chats/${getConversationId(userModel.uid)}/messages/').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo({required UserModel userModel}) {
    return _fireStore.collection('users').where("uid",isEqualTo: userModel.uid).snapshots();
  }

  Future<void> changeOnlineStatus(bool isOnline) {
    return _fireStore.collection('users').doc(_auth.currentUser!.uid).update({
      "isOnline" : isOnline
    });
  }

  Future sendMessage({required String message, required UserModel userModel}) async {
    MessageModel messageModel = MessageModel(
      type: Type.text,
      toUid: userModel.uid,
      fromUid: _auth.currentUser!.uid,
      message: message,
      read: "",
      sent: Timestamp.now(),
    );
    _fireStore.collection('chats/${getConversationId(userModel.uid)}/messages/').doc(DateTime.now().millisecondsSinceEpoch.toString()).set(messageModel.toMap());
  }

}
