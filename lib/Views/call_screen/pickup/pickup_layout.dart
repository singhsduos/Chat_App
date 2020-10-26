import 'package:ChatApp/Views/call_screen/pickup/pickup_screen.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/call_methods.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();


  PickupLayout({@required this.scaffold});

  @override
  Widget build(BuildContext context) { 
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    ClientRole _role = ClientRole.Broadcaster;

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(userId: userProvider.getUser.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data() != null) {
                Call call = Call.fromMap(snapshot.data.data());

                
                if (!call.hasDialled) {
                  return PickupScreen(
                    call: call,
                    role: _role,
                  );
                }
                return scaffold;
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
