class Call {
  String callerId;
  String callerName;
  String callerPic;
  String callerAboutMe;
  String callerEmail;
  // String callerCreatedAt;
  String receiverId;
  String receiverName;
  String receiverPic;
  String receiverAboutMe;
  String receiverEmail;
  String receiverCreatedAt;
  String channelId;
  bool hasDialled;
  String isCall;

  Call(
      {this.callerId,
      this.callerName,
      this.callerPic,
      this.receiverId,
      this.receiverName,
      this.receiverPic,
      this.channelId,
      this.hasDialled,
      this.callerAboutMe,
      this.callerEmail,
      // this.callerCreatedAt,
      this.receiverAboutMe,
      this.receiverEmail,
      this.receiverCreatedAt,
      this.isCall});

  //to map

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map<String, dynamic>();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["receiver_pic"] = call.receiverPic;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
    callMap["is_Call"] = call.isCall;
    callMap['caller_aboutMe'] = call.callerAboutMe;
    callMap['caller_email'] = call.callerEmail;
    // callMap['caller_createdAt'] = call.callerCreatedAt;
    callMap['receiver_aboutMe'] = call.receiverAboutMe;
    callMap['receiver_email'] = call.receiverEmail;
    callMap['receiver_createdAt'] = call.receiverCreatedAt;
    return callMap;
  }

  Call.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"].toString();
    this.callerName = callMap["caller_name"].toString();
    this.callerPic = callMap["caller_pic"].toString();
    this.receiverId = callMap["receiver_id"].toString();
    this.receiverName = callMap["receiver_name"].toString();
    this.receiverPic = callMap["receiver_pic"].toString();
    this.channelId = callMap["channel_id"].toString();
    this.callerAboutMe = callMap['caller_aboutMe'].toString();
    this.callerEmail = callMap['caller_email'].toString();
    // this.callerCreatedAt = callMap['caller_createdAt'].toString();
    this.receiverAboutMe = callMap['receiver_aboutMe'].toString();
    this.receiverEmail = callMap['receiver_email'].toString();
    this.receiverCreatedAt = callMap['receiver_createdAt'].toString();
    this.hasDialled = callMap['has_dialled'] as bool;
    this.isCall = callMap["is_Call"].toString();
  }
}
