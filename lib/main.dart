import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/helperfunctions.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CustomTheme(
    initialThemeKey: MyThemeKeys.LIGHT,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  dynamic getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      userIsLoggedIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatooApp',
      theme: CustomTheme.of(context),

      home: userIsLoggedIn ? ChatRoom() : Authenticate(),
      // home: ConversationScreen(),
      // home: ChatRoom(),
    );
  }
}
