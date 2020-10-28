import 'package:ChatApp/Views/call_screen/internet_call.dart';
import 'package:ChatApp/Views/call_screen/video_call_screen.dart';
import 'package:ChatApp/helper/strings.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/services/repository_log/log_repository.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/services/call_methods.dart';

class PickupScreen extends StatefulWidget {
  final Call call;
  final ClientRole role;

  PickupScreen({@required this.call, @required this.role});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true;
  void addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      callerId: widget.call.callerId,
      callerAboutMe: widget.call.callerAboutMe,
      callerEmail: widget.call.callerEmail,
      // callerCreatedAt: widget.call.callerCreatedAt,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      receiverId: widget.call.receiverId,
      receiverAboutMe: widget.call.receiverAboutMe,
      receiverCreatedAt: widget.call.receiverCreatedAt,
      receiverEmail: widget.call.receiverEmail,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      callStatus: callStatus,
      callType: widget.call.isCall,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    super.dispose();
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.cyan,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Incoming Call...',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(),
                    width: 90,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(125.0)),
                    ),
                  ),
                  errorWidget: (context, url, dynamic error) => Material(
                    child: Image.asset(
                      'images/placeHolder.jpg',
                      width: 150.0,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(125.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: widget.call.callerPic,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(125.0)),
                clipBehavior: Clip.hardEdge,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.call.callerName,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              (widget.call.isCall == 'audio')
                  ? Text(
                      'ChaTooApp voice call',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'ChaTooApp video call',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
              SizedBox(
                height: 75,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(13.0),
                    elevation: 2.0,
                    child: Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 40,
                    ),
                    fillColor: Colors.redAccent,
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await callMethods.endCall(call: widget.call);
                    },
                  ),
                  SizedBox(
                    width: 75,
                  ),
                  RawMaterialButton(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(13.0),
                    elevation: 2.0,
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 40,
                    ),
                    fillColor: Colors.greenAccent,
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      widget.call.isCall == "video"
                          ? await Permissions
                                  .cameraAndMicrophonePermissionsGranted()
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute<MaterialPageRoute>(
                                    builder: (context) => CallScreen(
                                      call: widget.call,
                                      role: widget.role,
                                    ),
                                  ),
                                )
                              : () {}
                          : await Permissions.microphonePermissionsGranted()
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute<MaterialPageRoute>(
                                    builder: (context) => VoiceCallScreen(
                                      call: widget.call,
                                      role: widget.role,
                                    ),
                                  ),
                                )
                              : () {};
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
