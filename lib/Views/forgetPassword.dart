import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

    return Scaffold(
      backgroundColor: Color(0xFF53E0BC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.clear, color: Color(0xFF53E0BC)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 23.0,
            fontFamily: 'EmilysCandy',
            letterSpacing: 1.0,
            color: const Color(0xFF53E0BC),
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Enter Your Email Address',
                      style: TextStyle(
                        fontSize: 23.0,
                        height: 7,
                        color: Colors.white.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0, right: 20, left: 20),
                      child: Text(
                        'We will send you a reset link',
                        style: TextStyle(
                          fontSize: 18.0,
                          height: 0,
                          color: Colors.white.withOpacity(1.0),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Theme(
                      data: ThemeData(
                        cursorColor: Colors.black,
                        hintColor: Color(0xFFFFFFFF),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 150, right: 20, left: 20),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : 'Enter Valid Email';
                                },
                                onSaved: (value) {
                                  setState(() {
                                    value;
                                  });
                                },
                                controller: emailTextEditingController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    child: Icon(
                                      Icons.mail_outline,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(22.0)),
                                      borderSide: BorderSide(
                                          color: Color(0xFFFFFFFF), width: 2)),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.0)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFFFFF)),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(22.0)),
                                      borderSide: BorderSide(
                                          color: Color(0xFFFFFFFF), width: 2)),
                                  hintText: 'Enter Your Email',
                                  labelText: 'E-mail',
                                  filled: true,
                                  labelStyle: new TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 17.0),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: RaisedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            authMethods
                                .resetPass(
                                    emailTextEditingController.text.trim())
                                .then((dynamic val) {
                              showToast("Email Sent", val,
                                  gravity: Toast.CENTER,
                                  duration: 3,
                                  textColor: Color(0xFF53E0BC),
                                  backgroundColor: Color(0xFFFFFFFF));

                              if (val != null) {
                                HelperFunctions.saveUserEmailSharedPreference(
                                    emailTextEditingController.text.trim());
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<MaterialPageRoute>(
                                        builder: (BuildContext context) =>
                                            ForgotPassword()));
                              }
                            }).catchError(
                              (dynamic val) {
                                showToast('Unkown Error', val,
                                    duration: 3,
                                    gravity: Toast.CENTER,
                                    textColor: Color(0xFF53E0BC),
                                    backgroundColor: Color(0xFFFFFFFF));
                              },
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        color: Color(0xFFFFFFFF),
                        child: Text(
                          'Send Mail',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'EmilysCandy',
                            letterSpacing: 1.0,
                            color: const Color(0xFF53E0BC),
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showToast(String msg, dynamic val,
      {int duration, int gravity, Color textColor, Color backgroundColor}) {
    // Toast.show(msg, context, duration: duration, gravity: gravity);
    Toast.show(msg, context,
        duration: duration,
        gravity: gravity,
        textColor: textColor,
        backgroundColor: backgroundColor);
  }
}
