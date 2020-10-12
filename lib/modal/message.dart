class Message {
  String id;
  String recevierId;
  String type;
  String message;
  String timestamp;
  String photoUrl;

  Message({this.id, this.recevierId, this.type, this.message, this.timestamp});

  //for images
  Message.imageMessage(
      {this.id,
      this.recevierId,
      this.message,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['recevierId'] = this.recevierId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }


  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['id'] = this.id;
    map['recevierId'] = this.recevierId;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.id = map['id'].toString();
    this.recevierId = map['recevierId'].toString();
    this.type = map['type'].toString();
    this.message = map['message'].toString();
    this.timestamp = map['timestamp'].toString();
     this.photoUrl = map['photoUrl'].toString();
  }
}
