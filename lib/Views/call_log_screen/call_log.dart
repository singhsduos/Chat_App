import 'package:ChatApp/Views/call_log_screen/call_log_contact.dart';
import 'package:ChatApp/Views/call_log_screen/widget/log_list_container.dart';
import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class LogScreen extends StatelessWidget {
  
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  LogScreen({this.analytics, this.observer});
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return PickupLayout(
      scaffold: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: () {
            Navigator.push<MaterialPageRoute>(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ContactListScreen()));
          },
          child: Icon(
            Icons.add_call,
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
