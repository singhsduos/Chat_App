import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class DatabaseMethods {
  final String username;
  DatabaseMethods({this.username});

  final CollectionReference users = Firestore.instance.collection("users");

  Future<String> getByUserName(String username) async {
    String user = '';
    await Firestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
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

  // Future<bool> authenticateUser(String user) async {
  //   QuerySnapshot result = '' as QuerySnapshot;
  //   await Firestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: user )
  //       .getDocuments();


  //       final List<DocumentSnapshot> docs = result.documents;
  //        return docs.length == 0 ? true : false;
  // }


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
