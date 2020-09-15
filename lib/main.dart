import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Views/signUp.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatooApp',
      theme: ThemeData(
        scaffoldBackgroundColor:  Color(0xfffeaf0f1),
        primarySwatch: Colors.cyan,
       
      ),

      home: Authenticate(),
      // home: MLHome(),
    );
  }
}
