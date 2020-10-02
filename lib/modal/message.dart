import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String chatRoomid;
  String type;
  String message;
  String timestamp;
  String photoUrl;

  Message(
      {this.id,
      this.chatRoomid,
      this.type,
      this.message,
      this.timestamp});

  //Will be only called when you wish to send an image
  // named constructor
  Message.imageMessage(
      {this.id,
      this.chatRoomid,
      this.message,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['chatRoomid'] = this.chatRoomid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  // named constructor
  Message.fromMap(Map<String, dynamic> map) {
    this.id = map['id'].toString();
    this.chatRoomid = map['chatRoomid'].toString();
    this.type = map['type'].toString();
    this.message = map['message'].toString();
    this.timestamp = map['timestamp'].toString();
  }

}