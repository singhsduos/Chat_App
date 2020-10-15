class Contact {
  String uid;
  String addedOn;

  Contact({
    this.uid,
    this.addedOn,
  });

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'].toString();
    this.addedOn = mapData['added_on'].toString();
  }
}
