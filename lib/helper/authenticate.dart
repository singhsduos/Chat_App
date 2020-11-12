import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Views/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Authenticate extends StatefulWidget {
  final String token;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  Authenticate({@required this.token, this.analytics, this.observer});

  @override
  _AuthenticateState createState() => _AuthenticateState(
      token: token, analytics: analytics, observer: observer);
}

class _AuthenticateState extends State<Authenticate> {
  String token;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _AuthenticateState({@required this.token, this.analytics, this.observer});
  bool showSignIn = true;
  bool isSwitched = false;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(token: token, analytics: analytics, observer: observer);
    } else {
      return SignUp(token: token, analytics: analytics, observer: observer);
    }
  }
}
