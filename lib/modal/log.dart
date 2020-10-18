class Log {
  int logId;
  String callerName;
  String callerPic;
  String receiverName;
  String receiverPic;
  String callStatus;
  String timestamp;

  Log({
    this.logId,
    this.callerName,
    this.callerPic,
    this.receiverName,
    this.receiverPic,
    this.callStatus,
    this.timestamp,
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
  }
}
