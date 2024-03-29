import 'dart:ui';
import 'package:ChatApp/Views/forgetPassword.dart';
import 'package:ChatApp/Views/signUp.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import '../Widget/widget.dart';
import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final String token;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  SignIn({@required this.token, this.analytics, this.observer});

  @override
  _SignInState createState() =>
      _SignInState(token: token, analytics: analytics, observer: observer);
}

class _SignInState extends State<SignIn> {
  String token;

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _SignInState({@required this.token, this.analytics, this.observer});
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;
  // QuerySnapshot snapshotUserInfo;
  Future<Null> signIn() async {
    prefs = await SharedPreferences.getInstance();
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text.trim(),
              passwordTextEditingController.text, context)
          .then(
        (dynamic result) async {
          if (result != null) {
            User user = FirebaseAuth.instance.currentUser;
            QuerySnapshot userInfoSnapshot = await FirebaseFirestore.instance
                .collection("users")
                .where("email",
                    isEqualTo: emailTextEditingController.text.trim())
                .get()
                .catchError((dynamic e) {
              print(e.toString());
            });
            final List<DocumentSnapshot> documents = userInfoSnapshot.docs;

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs[0].data()['username'].toString());
            HelperFunctions.saveUserEmailSharedPreference(
                userInfoSnapshot.docs[0].data()["email"].toString());
            await prefs.setString('id', '${documents[0].data()['id']}');
            await prefs.setString(
                'username', '${documents[0].data()['username']}');
            await prefs.setString(
                'photoUrl', '${documents[0].data()['photoUrl']}');
            await prefs.setString('email', '${documents[0].data()['email']}');
            await prefs.setString(
                'aboutMe', '${documents[0].data()['aboutMe']}');
            await prefs.setString('token', '${documents[0].data()['token']}');

            Fluttertoast.showToast(msg: "SignIn successful");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute<MaterialPageRoute>(
                    builder: (BuildContext context) =>
                        ChatRoom(analytics: analytics, observer: observer)));
          } else {
            setState(() {
              Fluttertoast.showToast(
                msg: "Invalid email/password",
                textColor: Color(0xFFFFFFFF),
                backgroundColor: Colors.cyan,
                fontSize: 16.0,
                timeInSecForIosWeb: 3,
              );
              isLoading = false;
            });
          }
        },
      );
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPreferences prefs;

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    final GoogleSignInAccount googleUser =
        await googleSignIn.signIn().catchError((dynamic e) {
      print(e);
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
          msg: 'SignUp fail',
        );
      });
    });
    if (googleUser == null) {
      Fluttertoast.showToast(msg: 'SignUp fail');
      this.setState(() {
        isLoading = false;
      });
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    User user = authResult.user;
    print("signed in " + user.displayName);

    // try{
    if (user != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // Update data to server if new user
        FirebaseFirestore.instance.collection('users').doc(user.uid)
            // ignore: always_specify_types
            .set(<String, dynamic>{
          'username': user.displayName,
          'photoUrl': user.photoURL,
          'id': user.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
          'email': user.email,
          'aboutMe': 'Hey there! I am using ChaTooApp',
          'token': token,
          // 'state' : null,
        });

        // Write data to local
        currentUser = user;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('username', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
        await prefs.setString('email', currentUser.email);
        await prefs.setString('token', token);
        await prefs.setString('aboutMe', 'Hey there! I am using ChaTooApp');
      } else {
        // Write data to local
        await prefs.setString('id', '${documents[0].data()['id']}');
        await prefs.setString('username', '${documents[0].data()['username']}');
        await prefs.setString('photoUrl', '${documents[0].data()['photoUrl']}');
        await prefs.setString('email', '${documents[0].data()['email']}');
        await prefs.setString('aboutMe', '${documents[0].data()['aboutMe']}');
        await prefs.setString('token', '${documents[0].data()['token']}');
      }
      Fluttertoast.showToast(msg: "SignIn successful");
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute<MaterialPageRoute>(
              builder: (BuildContext context) =>
                  ChatRoom(analytics: analytics, observer: observer)));
    }
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
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
                              prefixIcon: Container(
                                child: Icon(
                                  Icons.mail_outline,
                                  // color: Colors.black54,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22.0)),
                                borderSide:
                                    BorderSide(color: Colors.cyan, width: 2),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22.0)),
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.0)),
                                  borderSide:
                                      BorderSide(color: Colors.cyan, width: 2)),
                              hintText: 'Enter E-mail',
                              labelText: 'E-mail',
                              filled: true,
                              labelStyle: new TextStyle(
                                  color: Colors.cyan, fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter correct Password';
                              }
                              if (value.length < 7) {
                                return 'Enter correct Password';
                              }
                              if (value.length > 20) {
                                return 'Enter correct Password';
                              }
                              return null;
                            },
                            controller: passwordTextEditingController,
                            obscureText: _obscureText,
                            style: TextStyle(color: Colors.cyan),
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                child: Icon(
                                  Icons.vpn_key_outlined,
                                ),
                              ),
                              suffixIcon: Container(
                                child: IconButton(
                                  icon: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.0)),
                                  borderSide:
                                      BorderSide(color: Colors.cyan, width: 2)),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22.0)),
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.0)),
                                  borderSide:
                                      BorderSide(color: Colors.cyan, width: 2)),
                              hintText: 'Enter Password',
                              labelText: 'Password',
                              filled: true,
                              labelStyle: new TextStyle(
                                  color: Colors.cyan, fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<MaterialPageRoute>(
                                      builder: (BuildContext context) =>
                                          ForgotPassword()));
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: InkWell(
                                  child: Text('Forgot Password?',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Constants.prefs.setBool('userIsLoggedIn', true);
                              signIn();
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
                              child: Text('Sign In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Constants.prefs.setBool('userIsLoggedIn', true);
                              handleSignIn()
                                  .then((User user) => print(user))
                                  .catchError((dynamic e) => print(e));
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff99AAAB),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: AssetImage(
                                                  'images/signIn.png'),
                                            )),
                                            height: 40,
                                            width: 40,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Center(
                                          child: const Text(
                                            'Sign In with Google',

                                            // textDirection: ,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have account? ",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16)),
                              InkWell(
                                onTap: () {
                                  Navigator.push<MaterialPageRoute>(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignUp(token: token)));
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
