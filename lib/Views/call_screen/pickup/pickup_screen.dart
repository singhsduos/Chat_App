import 'package:ChatApp/Views/call_screen/internet_call.dart';
import 'package:ChatApp/Views/call_screen/video_call_screen.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/services/call_methods.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final ClientRole role;
  final CallMethods callMethods = CallMethods();
  PickupScreen({@required this.call, @required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
              child: Container(
          color: Colors.cyan,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(vertical:  70),
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
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 75),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(125.0)),
                    ),
                  ),
                  errorWidget: (context, url, dynamic error) => Material(
                    child: Image.asset(
                      'images/no_image.jpg',
                      width: 150.0,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(125.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: call.callerPic,
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
                call.callerName,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              (call.isCall == 'audio')
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
                      await callMethods.endCall(call: call);
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
                    onPressed: () async => call.isCall == "video"
                        ? await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute<MaterialPageRoute>(
                                  builder: (context) => CallScreen(
                                    call: call,
                                    role: role,
                                  ),
                                ),
                              )
                            : {dynamic}
                        : await Permissions.microphonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute<MaterialPageRoute>(
                                  builder: (context) => VoiceCallScreen(
                                    call: call,
                                    role: role,
                                  ),
                                ),
                              )
                            : {dynamic},
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
