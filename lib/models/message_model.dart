import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  final String toUid;
  final String fromUid;
  final String message;
  final String read;
  final Type   type;
  final Timestamp sent;

  const MessageModel({
    required this.toUid,
    required this.fromUid,
    required this.message,
    required this.read,
    required this.type,
    required this.sent,
  });

  Map<String, dynamic> toMap() {
    return {
      'toUid': toUid,
      'fromUid': fromUid,
      'message': message,
      'read': read,
      'type': type.name,
      'sent': sent,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      toUid: map['toUid'] as String,
      fromUid: map['fromUid'] as String,
      message: map['message'] as String,
      read: map['read'] as String,
      type: map['type'] as String == Type.image.name ? Type.image : Type.text,
      sent: map['sent'] as Timestamp,
    );
  }
}

enum Type{image,text}
