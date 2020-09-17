import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/helper/authenticate.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';

// ignore: avoid_void_async
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CustomTheme(
    initialThemeKey: MyThemeKeys.LIGHT,
    child: MyApp(),
  ));
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // final dynamic  ThemeProvider = Provider.of< dynamic ThemeProvider>(context, listen: false);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ChatooApp',
//             theme: defaultTargetPlatform == TargetPlatform.iOS
//           ? Themes.kIOSTheme
//           : Themes.kDefaultTheme,
//       // theme: ThemeProvider.getThemeData,
//       // theme: ThemeData(
//       // scaffoldBackgroundColor:  Colors.white,
//       // primarySwatch: Colors.cyan,
//       // brightness: _brightness
//       // ),

//       home: Authenticate(),
//       // home: MLHome(),
//       // home: ChatRoom(),
//     );
//   }
// }
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatooApp',
      theme: CustomTheme.of(context),
      // ThemeData(
      //   scaffoldBackgroundColor: Color(0xfffeaf0f1),
      //   primarySwatch: Colors.cyan,
      // ),

      home: Authenticate(),
      // home: MLHome(),
    );
  }
}