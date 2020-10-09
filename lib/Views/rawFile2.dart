import 'dart:io';

import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Views/drawer.dart';
import 'package:ChatApp/Views/search.dart';
import 'package:ChatApp/Views/search.dart';
import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Widget/customTile.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Views/account_setting.dart';

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

//   // Widget chatRoomList() {
//   //   return StreamBuilder<dynamic>(
//   //     stream: chatRoomsStream,
//   //     builder: (BuildContext context, AsyncSnapshot snapshot) {
//   //       return snapshot.hasData
//   //           ? ListView.builder(
//   //               itemCount: (int.parse('${snapshot.data.documents.length}')),
//   //               itemBuilder: (context, index) {
//   //                 return ChatRoomTile(
//   //                     '${snapshot.data.documents[index].data['chatroomid'].toString().replaceAll('_', "").replaceAll(Constants.myName, "")}',
//   //                     '${snapshot.data.documents[index].data['chatroomid']}'
//   //                     );
//   //               })
//   //           : Container();
//   //     },
//   //   );
//   // }

//   @override
//   void initState() {
//     super.initState();
//     databaseMethods.getCurrentUser().then((user) {
//       setState(() {
//         uid = user.uid;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
//       CustomTheme.instanceOf(buildContext).changeTheme(key);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: new IconThemeData(color: Colors.white),
//         title: Text(
//           'ChaTooApp',
//           style: TextStyle(
//             fontSize: 17.0,
//             fontFamily: 'UncialAntiqua',
//             letterSpacing: 1.0,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.cyan,
//       ),
//       drawer: SideDrawer(),
//       // body: chatRoomList(),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.cyan,
//         onPressed: () {
//           User user = FirebaseAuth.instance.currentUser;
//           Navigator.push<MaterialPageRoute>(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => Search(
//                         uid: user.uid,
//                       )));
//         },
//         child: Icon(
//           Icons.search,
//           color: Colors.white,
//         ),
//       ),
//       body: ChatRoomTile(uid),
//     );
//   }
// }

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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
// //    print(message['body'].toString());
// //    print(json.encode(message));

//     await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
//         message['body'].toString(), platformChannelSpecifics,
//         payload: json.encode(message));

// //    await flutterLocalNotificationsPlugin.show(
// //        0, 'plain title', 'plain body', platformChannelSpecifics,
// //        payload: 'item x');
//   }

  Future<bool> onBackPress() {
    // openDialog();
    return Future.value(false);
  }

  Users users;

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;
    return Scaffold(
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
      ),
      drawer: SideDrawer(),
      // body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          User user = FirebaseAuth.instance.currentUser;
          Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Search(currentUserId: user.uid)));
        },
        child: Icon(
          Icons.search,
          color: Colors.cyan,
        ),
      ),

      body: PickupLayout(
        scaffold: Scaffold(
          body: PageView(
            children: <Widget>[
              // List
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) =>
                            buildItem(context, snapshot.data.docs[index]),
                        itemCount: snapshot.data.docs.length,
                      );
                    }
                  },
                ),
              ),

              // Loading
              Center(
                child: Text(
                  'Call Logs',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
              ),
              
            ],
            controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: Colors.red,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 0)
                          ? Colors.blueAccent
                          : Colors.grey),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 0)
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: (_page == 1)
                          ? Colors.blueAccent
                          : Colors.grey),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone,
                      color: (_page == 2)
                          ? Colors.blueAccent
                          : Colors.grey),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 2)
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      

        ),
        // onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data()['id'] == uid) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document.data()['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.cyan),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: ('${document.data()['photoUrl']}'),
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: Colors.cyan,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${document.data()['username']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${document.data()['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<MaterialPageRoute>(
                    builder: (context) => ConversationScreen(
                          recevierId: document.id,
                          recevierAvatar: ('${document.data()['photoUrl']}'),
                          recevierName: '${document.data()['username']}',
                          recevierAbout: '${document.data()['aboutMe']}',
                          recevierCreate: '${document.data()['createdAt']}',
                          recevierMail: '${document.data()['email']}',
                        )));
          },
          color: Colors.cyan,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}




// agora app
// import io.agora.rtc.Constants;
// import io.agora.rtc.IRtcEngineEventHandler;
// import io.agora.rtc.RtcEngine;
// ...
// private void initializeAgoraEngine() {
//     try {
//         mRtcEngine = RtcEngine.create(getBaseContext(), getString(R.string.agora_app_id), mRtcEventHandler);
//     } catch (Exception e) {
//         Log.e(LOG_TAG, Log.getStackTraceString(e));
//         throw new RuntimeException("NEED TO check rtc sdk init fatal error" + Log.getStackTraceString(e));
//     }
// }

// enable video with agora
// mRtcEngine.enableVideo();

//join agora channel
// private void joinChannel() {
//   // if you do not specify the uid, Agora will assign one.
//   mRtcEngine.joinChannel(null, "demoChannel1", "Extra Optional Data", 0);
// }

//leave channel

        // private void leaveChannel() {
        //   mRtcEngine.leaveChannel();
        // }
      