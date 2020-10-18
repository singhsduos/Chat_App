import 'package:ChatApp/enum/users_state.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/utils/utilites.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods authMethods = AuthMethods();
  OnlineIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.OFFLINE:
          return Colors.redAccent;
        case UserState.ONLINE:
          return Colors.greenAccent;
        case UserState.WAITING:
          return Colors.yellowAccent;
        default:
          return Colors.redAccent;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: authMethods.getUsersStream(uid: uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshots) {
        Users users;
        if (snapshots.hasData && snapshots.data.data() != null) {
          users = Users.fromMap(snapshots.data.data());
        }
        return Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color:  getColor(users?.state)
          ),
        );
      },
    );
  }
}
