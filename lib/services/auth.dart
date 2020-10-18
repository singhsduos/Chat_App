import 'package:ChatApp/enum/users_state.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/utils/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User currentUser;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  Future showErrDialog(BuildContext context, String err) {
    // to hide the keyboard, if it is still p
    FocusScope.of(context).requestFocus(new FocusNode());
    return showDialog<dynamic>(
      context: context,
      child: AlertDialog(
        title: Text("Error"),
        content: Text(err),
        actions: <Widget>[
          OutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      print("signed in " + firebaseUser.email);
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      switch (e.toString()) {
        case 'ERROR_INVALID_EMAIL':
          showErrDialog(context, 'ERROR_INVALID_EMAIL');
          break;
        case 'ERROR_WRONG_PASSWORD':
          showErrDialog(context, 'ERROR_WRONG_PASSWORD');
      }
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      switch (e.toString()) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          showErrDialog(context, "Email Already Exists");
          break;
        case 'ERROR_INVALID_EMAIL':
          showErrDialog(context, "Invalid Email Address");
          break;
      }
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      // await googleSignIn.disconnect();
    } catch (e) {
      print(e.toString());
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    users.doc(userId).update(<String, dynamic>{'state': stateNum});
  }

  Stream<DocumentSnapshot> getUsersStream({
    @required String uid,
  }) =>
      users.doc(uid).snapshots();
}
