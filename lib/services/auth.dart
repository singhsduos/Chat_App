import 'package:ChatApp/modal/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      switch (e.code.toString()) {
        case 'Error_Email_Already_In_Use':
          print('serror');
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      switch (e.code.toString()) {
        case 'Error_Invalid_  Email':
          print('serror');
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

  Future signOut() async {
    try {
      User user = await _auth.currentUser;
      if(user.providerData[1].providerId == 'google.com'){
       return await googleSignIn.disconnect();
      }
      
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (GoogleSignInAuthentication != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      final User user = await _auth.currentUser;
      // final User user = authResult.user;
      print("signed in " + user.uid);
      // return user;
      return Future.value(true);
    }
  }
}
