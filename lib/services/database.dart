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

  Future<String> retrieveData(String username) async {
    final DocumentSnapshot snap = await users.document(username).get();
    Map<String, String> map = snap.data.toString() as Map<String, String>;
    String email = map['name'];
    return username;
  }
//

  // user data from snapshot
  Stream<QuerySnapshot> get userInfo {
    return users.snapshots();
  }
}
