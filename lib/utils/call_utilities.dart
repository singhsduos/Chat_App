import 'dart:math';
import 'package:ChatApp/Views/call_screen/internet_call.dart';
import 'package:ChatApp/Views/call_screen/video_call_screen.dart';
import 'package:ChatApp/helper/strings.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/call_methods.dart';
import 'package:ChatApp/services/repository_log/local_db.dart/hive.methods.dart';
import 'package:ChatApp/services/repository_log/local_db.dart/sqlite_methods.dart';
import 'package:ChatApp/services/repository_log/log_repository.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  HiveMethods hiveMethods = HiveMethods();
  SqliteMethods sqliteMethods = SqliteMethods();
  bool isHive;
  static final ClientRole _role = ClientRole.Broadcaster;
  static void dial(
      {Users from, Users to, BuildContext context, String callis}) async {
    Call call = Call(
      callerId: from.userId,
      callerName: from.username,
      callerPic: from.photoUrl,
      callerAboutMe: from.aboutMe,
      callerEmail: from.email,
      // callerCreatedAt: from.createdAt,
      receiverId: to.userId,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      receiverAboutMe: to.aboutMe,
      receiverCreatedAt: to.createdAt,
      receiverEmail: to.email,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.username,
      callerPic: from.photoUrl,
      callerId: from.userId,
      callerAboutMe: from.aboutMe,
      callerEmail: from.email,
      // callerCreatedAt: from.createdAt,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      receiverId: to.userId,
      receiverAboutMe: to.aboutMe,
      receiverCreatedAt: to.createdAt,
      receiverEmail: to.email,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;

    if (callMade) {
      LogRepository.addLogs(log);
      Navigator.push(
        context,
        MaterialPageRoute<MaterialPageRoute>(
          builder: (BuildContext context) => CallScreen(
            call: call,
            role: _role,
          ),
        ),
      );
    }
  }

  static void dialVoice(
      {Users from, Users to, BuildContext context, String callis}) async {
    Call call = Call(
      callerId: from.userId,
      callerName: from.username,
      callerPic: from.photoUrl,
      callerAboutMe: from.aboutMe,
      callerEmail: from.email,
      // callerCreatedAt: from.createdAt,
      receiverId: to.userId,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      receiverAboutMe: to.aboutMe,
      receiverCreatedAt: to.createdAt,
      receiverEmail: to.email,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.username,
      callerPic: from.photoUrl,
      callerId: from.userId,
      callerAboutMe: from.aboutMe,
      callerEmail: from.email,
      // callerCreatedAt: from.createdAt,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      receiverId: to.userId,
      receiverAboutMe: to.aboutMe,
      receiverCreatedAt: to.createdAt,
      receiverEmail: to.email,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    bool callMade = await callMethods.makeVoiceCall(call: call);
    call.hasDialled = true;

    if (callMade) {
      LogRepository.addLogs(log);
      Navigator.push(
        context,
        MaterialPageRoute<MaterialPageRoute>(
          builder: (BuildContext context) => VoiceCallScreen(
            call: call,
            role: _role,
          ),
        ),
      );
    }
  }
}
