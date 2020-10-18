import 'package:ChatApp/Views/call_log_screen/call_log.dart';
import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Views/chatView/chatList.dart';
import 'package:ChatApp/Views/drawer.dart';
import 'package:ChatApp/enum/users_state.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final String uid;

  ChatRoom({Key key, @required this.uid}) : super(key: key);

  @override
  State createState() => ChatRoomState(uid: uid);
}

class ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  ChatRoomState({Key key, @required this.uid});
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserProvider userProvider;
  PageController pageController;
  int _page = 0;

  final String uid;
  String currentUserId;
  String initials;
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    pageController = PageController();
    // registerNotification();
    // configLocalNotification();
  }

 

  // @override
  // void didChangeAppLifeCycleChanged(AppLifecycleState state) {
  //   String currentUserId =
  //       (userProvider != null && userProvider.getUser != null) ? userProvider.getUser.userId : "";
  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       currentUserId != null
  //           ? authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.ONLINE)
  //           : print('resumed');
  //       break;
  //     case AppLifecycleState.inactive:
  //       currentUserId != null
  //           ? authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.OFFLINE)
  //           : print('inactive');
  //       break;
  //     case AppLifecycleState.paused:
  //       currentUserId != null
  //           ? authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.WAITING)
  //           : print('paused');
  //       break;
  //     case AppLifecycleState.detached:
  //       currentUserId != null
  //           ? authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.OFFLINE)
  //           : print('detach');
  //       break;
  //   }
  // }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

//   void registerNotification() {
//     firebaseMessaging.requestNotificationPermissions();

//     firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
//       print('onMessage: $message');
//       Platform.isAndroid
//           ? showNotification(message['notification'])
//           : showNotification(message['aps']['alert']);
//       return;
//     }, onResume: (Map<String, dynamic> message) {
//       print('onResume: $message');
//       return;
//     }, onLaunch: (Map<String, dynamic> message) {
//       print('onLaunch: $message');
//       return;
//     });

//     firebaseMessaging.getToken().then((token) {
//       print('token: $token');
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .update({'pushToken': token});
//     }).catchError((err) {
//       Fluttertoast.showToast(msg: err.message.toString());
//     });
//   }

//   void configLocalNotification() {
//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('app_icon');
//     var initializationSettingsIOS = new IOSInitializationSettings();
//     var initializationSettings = new InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   void showNotification(message) async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//       Platform.isAndroid
//           ? 'com.dfa.flutterchatdemo'
//           : 'com.duytq.flutterchatdemo',
//       'Flutter chat demo',
//       'your channel description',
//       playSound: true,
//       enableVibration: true,
//       importance: Importance.Max,
//       priority: Priority.High,
//     );
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//     print(message);
  //  print(message['body'].toString());
  //  print(json.encode(message));

//     await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
//         message['body'].toString(), platformChannelSpecifics,
//         payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
//   }

  Future<bool> onBackPress() {
    return Future.value(true);
  }

  Users users;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: PickupLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            title: Text(
              'ChaTooApp',
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: 'UncialAntiqua',
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.cyan,
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "CHATS",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "CALLS",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          drawer: SideDrawer(),
          body: TabBarView(
            children: <Widget>[
              ChatListScreen(),
              LogScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
