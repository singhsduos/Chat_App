import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoggedIn = false;
  User currentUser;
  final _firestore = Firestore.instance;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  // ignore: missing_return
  Future<Null> signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'username': userNameTextEditingController.text,
        'email': emailTextEditingController.text.trim()
      }.cast<String, String>();
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text.trim());
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      setState(() {
        Fluttertoast.showToast(msg: "SignUp successful");
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
              emailTextEditingController.text.trim(), _pass.text)
          .then((dynamic signedInUser) {
        _firestore.collection('users').add(<String, String>{
          'username': userNameTextEditingController.text,
          'email': emailTextEditingController.text.trim(),
        }).then((dynamic value) {
          if (signedInUser != null) {
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute<MaterialPageRoute>(
                    builder: (BuildContext context) => ChatRoom()));
          }
        }).catchError((dynamic e) {
          print(e);
        });
      }).catchError((dynamic e) {
        print(e);
      });
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
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    User user = authResult.user;
    print("signed in " + user.displayName);

    if (user != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
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
        });

        // Write data to local
        currentUser = user;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('username', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
        await prefs.setString('email', currentUser.email);
      } else {
        // Write data to local
        await prefs.setString('id', '${documents[0].data()['id']}');
        await prefs.setString('username', '${documents[0].data()['username']}');
        await prefs.setString('photoUrl', '${documents[0].data()['photoUrl']}');
        await prefs.setString('email', '${documents[0].data()['email']}');
      }
      Fluttertoast.showToast(msg: "SignUp successful");
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute<MaterialPageRoute>(
              builder: (BuildContext context) => ChatRoom()));
    } else {
      Fluttertoast.showToast(msg: "SignUp fail");
      this.setState(() {
        isLoading = false;
      });
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) => value.isEmpty || value.length < 4
                            ? 'Username should be minimum 4 characters'
                            : null,
                        onSaved: (value) {
                          setState(() {
                            value;
                          });
                        },
                        controller: userNameTextEditingController,
                        style: TextStyle(color: Colors.cyan),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            child: Icon(
                              Icons.person_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
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
                              : 'Enter Valid Email';
                        },
                        onSaved: (value) {
                          setState(() {
                            value;
                          });
                        },
                        controller: emailTextEditingController,
                        style: TextStyle(color: Colors.cyan),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            child: Icon(
                              Icons.mail_outline,
                              color: Colors.black54,
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
                        controller: _pass,

                        validator: (value) => value.isEmpty || value.length < 7
                            ? 'Password should be minimum 7 characters'
                            : null,
                        onSaved: (value) {
                          setState(() {
                            value;
                          });
                        },
                        // controller: passwordTextEditingController,
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.cyan),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            child: Icon(
                              Icons.vpn_key_outlined,
                              color: Colors.black54,
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
                          labelStyle:
                              new TextStyle(color: Colors.cyan, fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _confirmPass,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 7)
                            return 'Password should be minimum 7 characters';
                          if (value != _pass.text) {
                            return 'Unmatch Password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            value;
                          });
                        },
                        // controller: passwordTextEditingController,
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.cyan),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            child: Icon(
                              Icons.vpn_key_outlined,
                              color: Colors.black54,
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
                          hintText: 'Retype Password',
                          labelText: 'Confirm Password',
                          filled: true,
                          labelStyle:
                              new TextStyle(color: Colors.cyan, fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: const Text('Sign Up with Google',
                                          textAlign: TextAlign.center,
                                          // textDirection: ,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          )),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'images/signIn.png'),
                                              fit: BoxFit.values[3])),
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                    )
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
                          Text("Already have account? ",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16)),
                          InkWell(
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
