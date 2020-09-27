import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final String username;
  DatabaseMethods({this.username});

  final CollectionReference users = Firestore.instance.collection("users");

  Future<QuerySnapshot> getByUserName(String username) async {
    QuerySnapshot user;
    await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();

    return user;
  }

  Future<String> getByUserEmail(String email) async {
    String email = '';
    await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();

    return email;
  }


  Future<void> uploadUserInfo(dynamic userMap) async {
    Map<String, String> userMap;
    return await Firestore.instance
        .collection("users")
        .add(userMap)
        .catchError((dynamic e) {
      print(e.toString());
    });
  }

  // user data from snapshot
  Stream<QuerySnapshot> get userInfo {
    return users.snapshots();
  }

  Future<void> createChatRoom(dynamic chatRoomMap, String chatRoomId) async {
    Map<String, dynamic> chatRoomMap;
    return await Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((dynamic e) {
      print(e);
    });
  }

  Future<void> addConversationMessages(
      String chatRoomid, dynamic messageMap) async {
    Map<String, dynamic> messageMap;
    return await Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomid)
        .collection('chats')
        .add(messageMap);
  }

  dynamic getConversationMessages(String chatRoomid) async {
    return await Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomid)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  dynamic getChatRooms(String username) async {
    return await Firestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
