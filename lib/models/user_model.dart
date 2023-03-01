import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String profilePic;
  final String about;
  final String name;
  final Timestamp createdAt;
  final String uid;
  final String lastActive;
  final String email;
  final String pushToken;
  final bool isOnline;

  const UserModel({
    required this.profilePic,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.uid,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'profilePic': profilePic,
      'about': about,
      'name': name,
      'createdAt': createdAt,
      'uid': uid,
      'lastActive': lastActive,
      'email': email,
      'pushToken': pushToken,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      profilePic: map['profilePic'] as String,
      about: map['about'] as String,
      name: map['name'] as String,
      createdAt: map['createdAt'] as Timestamp,
      uid: map['uid'] as String,
      lastActive: map['lastActive'] as String,
      email: map['email'] as String,
      pushToken: map['pushToken'] as String,
      isOnline: map['isOnline'] as bool,
    );
  }
}
