import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/widget.dart';

import '../Widget/widget.dart';
import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  void signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text.trim());

      databaseMethods
          .getByUserEmail(emailTextEditingController.text.trim())
          .then((val) {
        snapshotUserInfo = val as QuerySnapshot;
        HelperFunctions.saveUserNameSharedPreference(
            "${snapshotUserInfo.docs[0].data()['name']}");
        // print("${snapshotUserInfo.docs[0].data()['name']} this is not good");
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text.trim(),
              passwordTextEditingController.text)
          .then((dynamic val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute<MaterialPageRoute>(
                  builder: (BuildContext context) => ChatRoom()));
        }
      });
    }
  }

  void performLogin() {
    setState(() {
      isLoading = true;
    });

    authMethods.handleSignIn().then((User user) {
      if (user != null) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<MaterialPageRoute>(
                builder: (BuildContext context) => ChatRoom()));
      } else {
        print("There was an error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    isLoading
                          ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(),
                    TextFormField(
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                            ? null
                            : 'Enter correct email';
                      },
                      controller: emailTextEditingController,
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
                        labelStyle:
                            new TextStyle(color: Colors.cyan, fontSize: 16.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.length > 5
                            ? null
                            : "Enter Username 6+ characters";
                      },
                      controller: passwordTextEditingController,
                      obscureText: true,
                      style: TextStyle(color: Colors.cyan),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(22.0)),
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 2)),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        filled: true,
                        labelStyle:
                            new TextStyle(color: Colors.cyan, fontSize: 16.0),
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
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xfff4BCFFA),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Text('Sign In',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        performLogin();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xfff99AAAB),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Text('Sign In with Google',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                      ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
