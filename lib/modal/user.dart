import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userId;
  String username;
  String email;
  String photoUrl;
  String createdAt;
  String aboutMe;
  // int state;

  Users({
    this.userId,
    this.username,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.aboutMe,
    // this.state,
  });

  factory Users.fromDocument(DocumentSnapshot doc) {
    // ignore: always_specify_types
    final Map getDocs = doc.data();
    return Users(
      userId: getDocs['id'].toString(),
      email: getDocs['email'].toString(),
      username: getDocs['username'].toString(),
      photoUrl: getDocs['photoUrl'].toString(),
      createdAt: getDocs['createdAt'].toString(),
      aboutMe: getDocs['aboutMe'].toString(),
      // state: int.parse(getDocs['state'].toString()),
    );
  }

  Map toMap(Users users) {
    var data = Map<String, dynamic>();
    data['id'] = users.userId;
    data['email'] = users.email;
    data['username'] = users.username;
    data['photoUrl'] = users.photoUrl;
    data[' createdAt'] = users.createdAt;
    data['aboutMe'] = users.aboutMe;
    // data['state'] = users.state;
    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.userId = mapData['id'].toString();
    this.email = mapData['email'].toString();
    this.username = mapData['username'].toString();
    this.photoUrl = mapData['photoUrl'].toString();
    this.createdAt = mapData['createdAt'].toString();
    this.aboutMe = mapData['aboutMe'].toString();
    // this.state = int.parse(mapData['state'].toString());
  }
}
