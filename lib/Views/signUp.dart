import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/helper/authenticate.dart';
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
  final String token;
  SignUp({Key key, this.toggle, this.token}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState(this.token);
}

class _SignUpState extends State<SignUp> {
  final String token;
  _SignUpState(
    this.token,
  );
  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // ignore: missing_return
  Future<Null> signMeUp() async {
    prefs = await SharedPreferences.getInstance();
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signUpWithEmailAndPassword(
              emailTextEditingController.text.trim(), _pass.text, context)
          .then((dynamic signedInUser) async {
        if (signedInUser != null) {
          User user = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(<String, dynamic>{
            'username': userNameTextEditingController.text,
            'email': emailTextEditingController.text.trim(),
            'id': FirebaseAuth.instance.currentUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null,
            'photoUrl': user.photoURL,
            'aboutMe': 'Hey there! I am using ChaTooApp',
            'token': token,

            //  'state' : null,
          }).catchError((dynamic e) {
            print(e);
            User user = FirebaseAuth.instance.currentUser;
            if (signedInUser == null) {
              setState(() {
                isLoading = false;

                Fluttertoast.showToast(
                  msg: 'Email already in use',
                  textColor: Color(0xFFFFFFFF),
                  backgroundColor: Colors.cyan,
                  fontSize: 16.0,
                  timeInSecForIosWeb: 4,
                );
                return Authenticate();
              });
            } else {
              print(user.uid);
              setState(() {
                isLoading = false;

                Fluttertoast.showToast(
                  msg: 'Email already in use',
                  textColor: Color(0xFFFFFFFF),
                  backgroundColor: Colors.cyan,
                  fontSize: 16.0,
                  timeInSecForIosWeb: 4,
                );
                return ChatRoom();
              });
            }
          });

          Fluttertoast.showToast(msg: "SignUp successful");
          print("signed up " + emailTextEditingController.text.trim());
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userNameTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailTextEditingController.text.trim());

          await prefs.setString('id', user.uid);
          await prefs.setString('username', userNameTextEditingController.text);
          await prefs.setString('photoUrl', user.photoURL);
          await prefs.setString(
              'email', emailTextEditingController.text.trim());
          await prefs.setString('aboutMe', 'Hey there! I am using ChaTooApp');
          await prefs.setString('token', token);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute<MaterialPageRoute>(
                  builder: (BuildContext context) => ChatRoom()));
        } else {
          User user = FirebaseAuth.instance.currentUser;
          if (signedInUser == null) {
            setState(() {
              isLoading = false;

              Fluttertoast.showToast(
                msg: 'Email already in use',
                textColor: Color(0xFFFFFFFF),
                backgroundColor: Colors.cyan,
                fontSize: 16.0,
                timeInSecForIosWeb: 4,
              );
              return Authenticate();
            });
          } else {
            print(user.uid);
            setState(() {
              isLoading = false;

              Fluttertoast.showToast(
                msg: 'Email already in use',
                textColor: Color(0xFFFFFFFF),
                backgroundColor: Colors.cyan,
                fontSize: 16.0,
                timeInSecForIosWeb: 4,
              );
              return ChatRoom();
            });
          }
        }
      }).catchError((dynamic e) {
        print(e);
        User user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          setState(() {
            isLoading = false;

            Fluttertoast.showToast(
              msg: 'Email already in use',
              textColor: Color(0xFFFFFFFF),
              backgroundColor: Colors.cyan,
              fontSize: 16.0,
              timeInSecForIosWeb: 4,
            );
            return;
          });
        } else {
          print(user.uid);
          setState(() {
            isLoading = false;

            Fluttertoast.showToast(
              msg: 'Email already in use',
              textColor: Color(0xFFFFFFFF),
              backgroundColor: Colors.cyan,
              fontSize: 16.0,
              timeInSecForIosWeb: 4,
            );
            return ChatRoom();
          });
        }
      });
    }
  }

  SharedPreferences prefs;

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    final GoogleSignInAccount googleUser = await googleSignIn
        .signIn()
        .catchError((dynamic onError) => print(onError));
    if (googleUser == null) {
      Fluttertoast.showToast(msg: 'SignUp fail');

      this.setState(() {
        isLoading = false;
        Authenticate();
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
      Fluttertoast.showToast(msg: 'SignUp successful');
      this.setState(() {
        isLoading = false;
      });
      //  User user = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<MaterialPageRoute>(
              builder: (BuildContext context) => ChatRoom()));
    } else {
      Fluttertoast.showToast(msg: 'SignUp fail');
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
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Username can't be empty";
                          }
                          if (value.length < 4) {
                            return 'Password must be atleast 4 characters long';
                          }
                          if (value.length > 20) {
                            return 'Password must be less than 20 characters';
                          }
                          return null;
                        },
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

                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Password can't be empty";
                          }
                          if (value.length < 7) {
                            return 'Password must be atleast 7 characters long';
                          }
                          if (value.length > 20) {
                            return 'Password must be less than 20 characters';
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
                          if (value.isEmpty) return "Password can't be empty";
                          if (value.length < 7)
                            return 'Password must be atleast 7 characters long';
                          if (value.length > 20) {
                            return 'Password must be less than 20 characters';
                          }

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
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image:
                                              AssetImage('images/signIn.png'),
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
                                      child: const Text('Sign Up with Google',

                                          // textDirection: ,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          )),
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
                          Text("Already have account? ",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16)),
                          InkWell(
                            onTap: () {
                              Navigator.push<MaterialPageRoute>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignIn(token: token)));
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
