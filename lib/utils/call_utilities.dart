import 'dart:math';

import 'package:ChatApp/Views/call_screen/call_screen.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/call_methods.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
 static final ClientRole _role = ClientRole.Broadcaster;
  static void dial({Users from, Users to, BuildContext context}) async {
    Call call = Call(
      callerId: from.userId,
      callerName: from.username,
      callerPic: from.photoUrl,
      receiverId: to.userId,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      channelId: Random().nextInt(1000).toString(),
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute<MaterialPageRoute>(
          builder: (BuildContext context) => CallScreen(call: call, role: _role,),
        ),
      );
    }
    
  }
}
