class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool hasDialled;

  Call({
     this.callerId,
  this.callerName,
  this.callerPic,
  this.receiverId,
  this.receiverName,
  this.receiverPic,
  this.channelId,
  this.hasDialled,
  });

  //to map

    Map <String, dynamic>toMap(Call call) {
    Map<String, dynamic> callMap = Map<String,dynamic>();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["receiver_pic"] = call.receiverPic;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
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
    this.hasDialled = callMap['has_dialled'] as bool;
  }
}
