import 'dart:async';
import 'package:ChatApp/modal/contacts.dart';
import 'package:ChatApp/modal/message.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  final String username;
  DatabaseMethods({this.username});

  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  Users user = Users();

// DataStorage Methods
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  Future<Users> getUserDetails() async {
    User currentUser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot = await users.doc(currentUser.uid).get();

    return Users.fromMap(documentSnapshot.data());
  }

  Future<QuerySnapshot> getByUserName(String username) async {
    QuerySnapshot user;
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return user;
  }

  Future<Users> getUserDetailsById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(id).get();
      return Users.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getByUserEmail(String email) async {
    String email = '';
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return email;
  }

  Future<List<Users>> fetchAllUsers(User currentUser) async {
    List<Users> userList = List<Users>();

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Users.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

// chat methods
  Message message;
  DocumentReference getContactsDocument({String of, String forContact}) =>
      users.doc(of).collection('contacts').doc(forContact);

  Future<void> addToContacts({String senderId, String receiverId}) async {
    String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    String currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap =
          receiverContact.toMap(receiverContact) as Map<String, dynamic>;

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    String currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap =
          senderContact.toMap(senderContact) as Map<String, dynamic>;

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  User _user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> fetchContacts({String userId}) =>
      users.doc(userId).collection('contacts').orderBy("added_on", descending: true)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String id,
    @required String receiverId,
  }) =>
      FirebaseFirestore.instance
          .collection('messages')
          .doc(id)
          .collection(receiverId)
          .orderBy("timestamp", descending: false)
          .snapshots();
  // user data from snapshot
  Stream<QuerySnapshot> get userInfo {
    return users.snapshots();
  }

  Future<void> addConversationMessages(
      Message message, Users sender, Users receiver) async {
    var map = message.toMap() as Map<String, dynamic>;
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(message.id)
        .collection(message.recevierId)
        .add(map);

    addToContacts(senderId: message.id, receiverId: message.recevierId);

    return await FirebaseFirestore.instance
        .collection('messages')
        .doc(message.recevierId)
        .collection(message.id)
        .add(map);
  }
}
