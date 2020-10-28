class Log {
  int logId;
  String callerName;
  String callerPic;
  String callerId;
  String receiverName;
  String receiverPic;
  String receiverId;
  String callStatus;
  String timestamp;
  String callerAboutMe;
  String callerEmail;
  // String callerCreatedAt;
  String receiverAboutMe;
  String receiverEmail;
  String receiverCreatedAt;
  String callType;

  Log({
    this.logId,
    this.callerName,
    this.callerPic,
    this.receiverName,
    this.receiverPic,
    this.callStatus,
    this.timestamp,
    this.callerAboutMe,
    this.callerEmail,
    // this.callerCreatedAt,
    this.receiverAboutMe,
    this.receiverEmail,
    this.receiverCreatedAt,
    this.callerId,
    this.receiverId,
    this.callType,
  });

  // to map
  Map<String, dynamic> toMap(Log log) {
    Map<String, dynamic> logMap = Map<String, dynamic>();
    logMap["log_id"] = log.logId;
    logMap["caller_name"] = log.callerName;
    logMap["caller_pic"] = log.callerPic;
    logMap["receiver_name"] = log.receiverName;
    logMap["receiver_pic"] = log.receiverPic;
    logMap["call_status"] = log.callStatus;
    logMap["timestamp"] = log.timestamp;
    logMap['caller_aboutMe'] = log.callerAboutMe;
    logMap['caller_email'] = log.callerEmail;
    // logMap['caller_createdAt'] = log.callerCreatedAt;
    logMap['receiver_aboutMe'] = log.receiverAboutMe;
    logMap['receiver_email'] = log.receiverEmail;
    logMap['receiver_createdAt'] = log.receiverCreatedAt;
    logMap["caller_id"] = log.callerId;
    logMap["receiver_id"] = log.receiverId;
    logMap["call_type"] = log.callType;
    return logMap;
  }

  Log.fromMap(Map logMap) {
    this.logId = int.parse(logMap["log_id"].toString());
    this.callerName = logMap["caller_name"].toString();
    this.callerPic = logMap["caller_pic"].toString();
    this.receiverName = logMap["receiver_name"].toString();
    this.receiverPic = logMap["receiver_pic"].toString();
    this.callStatus = logMap["call_status"].toString();
    this.timestamp = logMap["timestamp"].toString();
    this.callerAboutMe = logMap['caller_aboutMe'].toString();
    this.callerEmail = logMap['caller_email'].toString();
    // this.callerCreatedAt = logMap['caller_createdAt'].toString();
    this.receiverAboutMe = logMap['receiver_aboutMe'].toString();
    this.receiverEmail = logMap['receiver_email'].toString();
    this.receiverCreatedAt = logMap['receiver_createdAt'].toString();
    this.callerId = logMap["caller_id"].toString();
    this.receiverId = logMap["receiver_id"].toString();
    this.callType = logMap["call_type"].toString();
  }
}
