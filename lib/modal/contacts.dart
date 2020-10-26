class Contact {
  String uid;
  String addedOn;
  String photoUrl;
  String username;

  Contact({this.uid, this.addedOn, this.photoUrl, this.username});

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    data['photoUrl'] = contact.photoUrl;
    data['username'] = contact.username;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'].toString();
    this.addedOn = mapData['added_on'].toString();
    this.photoUrl = mapData['photoUrl'].toString();
    this.username = mapData['username'].toString();
  }
}
