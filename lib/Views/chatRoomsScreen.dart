import 'package:ChatApp/Views/call_log_screen/call_log.dart';
import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Views/chatView/chatList.dart';
import 'package:ChatApp/Views/drawer.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/services/repository_log/log_repository.dart';
import 'package:ChatApp/utils/utilites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class ChatRoom extends StatefulWidget {
 
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  ChatRoom({@required this.analytics, this.observer});
  @override
  _ChatRoomState createState() => _ChatRoomState(analytics:analytics, observer:observer);
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
   _ChatRoomState({@required this.analytics, this.observer});
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  UserProvider userProvider;
  PageController pageController;
  int _page = 0;

  String uid;
  String currentUserId;
  String initials;

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;
  User user = FirebaseAuth.instance.currentUser;

  

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.refreshUser();
      WidgetsBinding.instance.addObserver(this);

      databaseMethods.getCurrentUser().then((user) {
        setState(() {
          isLoading = false;
          currentUserId = user.uid;
          // initials = Utils.getInitials(user.displayName);
        });
      });

      LogRepository.init(isHive: false, dbName: user.uid);
    });
    pageController = PageController();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showMessage('Notification', '$message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showMessage('Notification', '$message');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showMessage('Notification', '$message');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  dynamic showMessage(String title, String description) {
    showDialog<Widget>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
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
              ChatListScreen(analytics: analytics, observer: observer),
              LogScreen(analytics: analytics, observer: observer),
            ],
          ),
        ),
      ),
    );
  }
}
