import 'package:ChatApp/helper/strings.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection(CALL_COLLECTION);
  Stream<DocumentSnapshot> callStream({String userId}) =>
      callCollection.doc(userId).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      call.isCall = "video";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "video";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

    Future<bool> makeVoiceCall({Call call}) async {
    try {
      call.hasDialled = true;
      call.isCall = "audio";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "audio";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
