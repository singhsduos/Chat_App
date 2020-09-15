import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/widget.dart';

import '../Widget/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.cyan),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                    borderSide: BorderSide(color: Colors.cyan, width: 2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter E-mail',
                  labelText: 'E-mail',
                  filled: true,
                  labelStyle: new TextStyle(color: Colors.cyan, fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.cyan),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.0)),
                      borderSide: BorderSide(color: Colors.cyan, width: 2)),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  filled: true,
                  labelStyle: new TextStyle(color: Colors.cyan, fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text('Forgot Password?',
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xfff4BCFFA),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Text('Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xfff99AAAB),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Text('Sign in with Google',
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have account? ",
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
