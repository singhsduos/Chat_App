import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_void_async
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatooApp',
        theme: CustomTheme.of(context),
         home: Constants.prefs.getBool('userIsLoggedIn') == true ? ChatRoom() : Authenticate()

        // home: ConversationScreen(),
        // home: ChatRoom(),
        );
  }
}
