import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/provider/image_upload_provider.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:flutter/services.dart';
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
  final DatabaseMethods _authenticationMethods = DatabaseMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // static const platform = const MethodChannel('TokenChannel');
  bool userIsLoggedIn;
  String token;
  dynamic _getdeviceToken() async {
    await _firebaseMessaging.getToken().then((deviceToken) {
      setState(() {
        token = deviceToken.toString();
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();

    super.initState();
    _getdeviceToken();
    // sendData();
    Future.delayed(Duration(milliseconds: 500), () {
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
    });
  }

  // Future<void> sendData() async {
  //   String message;
  //   try {
  //     message = await platform.invokeMethod(token);
  //     print(message);
  //   } on PlatformException catch (e) {
  //     message = "Failed to get data from native : '${e.message}'.";
  //   }
  // }

  void getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }
      // print( token);

    // User user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ChatooApp',
              theme:
                  notifier.darkTheme ? MyThemes.darkTheme : MyThemes.lightTheme,
              home: Constants.prefs.getBool('userIsLoggedIn') == true
                  ? ChatRoom()
                  : Authenticate(token: token));
        },
      ),
    );
  }
}