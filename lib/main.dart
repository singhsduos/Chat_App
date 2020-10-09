import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Views/forgetPassword.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:provider/provider.dart';
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
  bool userIsLoggedIn;
  @override
  void initState() {
    getLoggedInState();

    super.initState();
  }

  void getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // User user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ChatooApp',
              theme: CustomTheme.of(context),
              home: Constants.prefs.getBool('userIsLoggedIn') == true
                  ? ChatRoom(
                      uid: null,
                    )
                  : Authenticate()

              // home: ConversationScreen(),
              // home: ForgotPassword(),
              );
        },
      ),
    );
  }
}
