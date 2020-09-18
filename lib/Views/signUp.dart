import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'chatRoomsScreen.dart';


import '../Widget/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  dynamic signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> userInfoMap = {
        'name': userNameTextEditingController.text,
        'email': emailTextEditingController.text.trim()
      }.cast<String, dynamic>();
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text.trim());
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text.trim(),
              passwordTextEditingController.text)
          .then((dynamic val) {
        if (val != null) {
          // ignore: always_specify_types

          // ignore: unnecessary_parenthesis
          databaseMethods.uploadUserInfo((userInfoMap));
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
        final Map<String, dynamic> userInfoMap = {
          'name': userNameTextEditingController.text,
          'email': emailTextEditingController.text.trim()
        }.cast<String, dynamic>();
        // ignore: unnecessary_parenthesis
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<MaterialPageRoute>(
                builder: (BuildContext context) => ChatRoom()));
      } else {
         setState(() {
            isLoading = false;
             print("There was an error");
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 3
                              ? 'Enter Username 3+ characters'
                              : null;
                        },
                        controller: userNameTextEditingController,
                        style: TextStyle(color: Colors.cyan),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.0)),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          hintText: 'Enter Username',
                          labelText: 'Username',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.0)),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
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
                              : "Enter Password 6+ characters";
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
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
                      GestureDetector(
                        onTap: () {
                          Constants.prefs.setBool('userIsLoggedIn', true);
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xfff4BCFFA),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Text('Sign Up',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            child: Text('Sign Up with Google',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have account? ",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16)),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'SignIn now',
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
            ),
    );
  }
}
