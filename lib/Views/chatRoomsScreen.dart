import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Views/chatView/chatList.dart';
import 'package:ChatApp/Views/drawer.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class ChatRoom extends StatefulWidget {
//   String uid;
//   ChatRoom({Key key, @required this.uid}) : super(key: key);
//   @override
//   _ChatRoomState createState() => _ChatRoomState(uid);
// }

// AuthMethods authMethods = AuthMethods();
// DatabaseMethods databaseMethods = DatabaseMethods();

// class _ChatRoomState extends State<ChatRoom> {
//   String uid;
//   _ChatRoomState(this.uid);

//   Stream chatRoomsStream;

// Widget chatRoomList() {
//   return StreamBuilder<dynamic>(
//     stream: chatRoomsStream,
//     builder: (BuildContext context, AsyncSnapshot snapshot) {
//       return snapshot.hasData
//           ? ListView.builder(
//               itemCount: (int.parse('${snapshot.data.documents.length}')),
//               itemBuilder: (context, index) {
//                 return ChatRoomTile(
//                     '${snapshot.data.documents[index].data['chatroomid'].toString().replaceAll('_', "").replaceAll(Constants.myName, "")}',
//                     '${snapshot.data.documents[index].data['chatroomid']}'
//                     );
//               })
//           : Container();
//     },
//   );
// }

//   @override
//   void initState() {
//     super.initState();
//     databaseMethods.getCurrentUser().then((user) {
//       setState(() {
//         uid = user.uid;
//       });
//     });
//   }

// class ChatRoomTile extends StatefulWidget {
//   final String uid;
//   ChatRoomTile(this.uid);

//   @override
//   _ChatRoomTileState createState() => _ChatRoomTileState();
// }

// class _ChatRoomTileState extends State<ChatRoomTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//         padding: EdgeInsets.all(10),
//         itemCount: 2,
//         itemBuilder: (context, index) {
//           return CustomTile(
//             mini: false,
//             onTap: () {},
//             title: Text(
//               'Neelesh Singh',
//               style: TextStyle(
//                 fontSize: 19,
//               ),
//             ),
//             subtitle: Text(
//               'hello',
//               style: TextStyle(fontSize: 14),
//             ),
//             leading: Container(
//               constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
//               child: Stack(
//                 children: <Widget>[
//                   CircleAvatar(
//                     maxRadius: 30,
//                     backgroundColor: Colors.black,
//                     backgroundImage: NetworkImage(
//                         'https://images.unsplash.com/photo-1565464027194-7957a2295fb7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=80'),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Container(
//                       height: 15,
//                       width: 15,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.greenAccent,
//                           border: Border.all(
//                             color: Colors.black,
//                             width: 2,
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/scheduler.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final String uid;

  ChatRoom({Key key, @required this.uid}) : super(key: key);

  @override
  State createState() => ChatRoomState(uid: uid);
}

class ChatRoomState extends State<ChatRoom> {
  ChatRoomState({Key key, @required this.uid});
  AuthMethods authMethods = AuthMethods();
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserProvider userProvider;
  PageController pageController;
  int _page = 0;

  final String uid;
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;

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
              Calls(),
            ],
          ),
        ),
      ),
    );
  }
}

class Calls extends StatefulWidget {
  CallsState createState() => CallsState();
}

class CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.wwe.com/f/styles/og_image/public/all/2016/07/John_Cena_bio--b51ea9d0b6f475af953923ac7791391b.jpg'),
          ),
          title: Text('Bhavya'),
          subtitle: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
              Text('Today 1:25 pm'),
            ],
          ),
          trailing: Icon(
            Icons.phone,
            color: Color(0xFF075e54),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.wwe.com/f/styles/og_image/public/all/2016/07/John_Cena_bio--b51ea9d0b6f475af953923ac7791391b.jpg'),
          ),
          title: Text('Bhavya'),
          subtitle: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
              Text('Today 1:25 pm'),
            ],
          ),
          trailing: Icon(
            Icons.phone,
            color: Color(0xFF075e54),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.wwe.com/f/styles/og_image/public/all/2016/07/John_Cena_bio--b51ea9d0b6f475af953923ac7791391b.jpg'),
          ),
          title: Text('Bhavya'),
          subtitle: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
              Text('Today 1:25 pm'),
            ],
          ),
          trailing: Icon(
            Icons.phone,
            color: Color(0xFF075e54),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.wwe.com/f/styles/og_image/public/all/2016/07/John_Cena_bio--b51ea9d0b6f475af953923ac7791391b.jpg'),
          ),
          title: Text('Bhavya'),
          subtitle: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
              Text('Today 1:25 pm'),
            ],
          ),
          trailing: Icon(
            Icons.video_call,
            color: Color(0xFF075e54),
          ),
        ),
      ],
    );
  }
}
