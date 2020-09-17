import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseMethods {
//   dynamic getUserByUserName(String username) {
//     Firestore.instance
//         .collection('users')
//         .where("name", isEqualTo: username)
//         .getDocuments();
//   }

//   dynamic uploadUserInfo(String name, String email) {
//     Firestore.instance.collection('users').add(userMap).catchError((dynamic e) {
//       print(e.toString());
//     });
//   }
// }

class DatabaseMethods {
  final String username;
  DatabaseMethods({this.username});

  final CollectionReference users = Firestore.instance.collection("users");

  Future<String> getByUserName(String username) async {
    String user = '';
    await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();

    return user;
  }

  Future<String> getByUserEmail(String username) async {
    String user = '';
    await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();

    return user;
  }

  // Future<String> retrieveData(String username) async {
  //   final DocumentSnapshot snap = await users.document(username).get();
  //   Map<String, String> map = snap.data.toString() as Map<String, String>;
  //   final String email = map['name'];
  //   return username;
  // }

  dynamic uploadUserInfo(dynamic userMap) {
    Firestore.instance
        .collection('users')
        .add({userMap})
        .then((value) => print('User Added'))
        .catchError((dynamic e) {
          print(e.toString());
        });
  }

  // user data from snapshot
  Stream<QuerySnapshot> get userInfo {
    return users.snapshots();
  }

  dynamic createChatRoom(String chatroomid, dynamic chatRoomMap) {
    Firestore.instance
        .collection('ChatRoom')
        .document(chatroomid)
        .setData({chatRoomMap})
        .then((value) => print('User Added'))
        .catchError((dynamic e) {
          print(e.toString());
        });
  }

  dynamic addConversationMessages(String chatRoomid, dynamic messageMap) {
    Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomid)
        .collection('chats')
        .add(messageMap)
        .then((value) => print('User Added'))
        .catchError((dynamic error) => print("Failed to add user: $error"));
  }

  dynamic getConversationMessages(String chatRoomid) async {
    return await Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomid)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  dynamic getChatRooms(String userName) async{
    return await Firestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
