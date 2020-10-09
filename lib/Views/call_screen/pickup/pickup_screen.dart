import 'package:ChatApp/Views/call_screen/call_screen.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
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
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Incoming...',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Image.network(
              call.callerPic,
              // isAntiAlias: true,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              call.callerName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.greenAccent,
                  onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted() ? Navigator.push(
                    context,
                    MaterialPageRoute<MaterialPageRoute>(
                      builder: (context) => CallScreen(call:call, role: role,),
                    ),
                  ): {dynamic},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
