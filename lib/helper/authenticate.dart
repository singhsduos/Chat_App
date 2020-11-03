import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Views/signUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  final String token;
  Authenticate({Key key,this.token}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState(this.token);
}

class _AuthenticateState extends State<Authenticate> {
 String token;
  _AuthenticateState(this.token);
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
      return SignIn(token:token);
    } else {
      return SignUp(token:token);
    }
  }
}
