import 'dart:core';
import 'package:flutter/material.dart';
import 'Views/signIn.dart';

// ignore: avoid_void_async
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatoo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),

      home: SignIn(),
      // home: MLHome(),
    );
  }
}
