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
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  String uid;
  ChatRoom({Key key, @required this.uid}) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState(uid);
}

AuthMethods authMethods = AuthMethods();
DatabaseMethods databaseMethods = DatabaseMethods();

class _ChatRoomState extends State<ChatRoom> {
  String uid;
  _ChatRoomState(this.uid);

  Stream chatRoomsStream;

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

  @override
  void initState() {
    super.initState();
    databaseMethods.getCurrentUser().then((user) {
      setState(() {
        uid = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

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
        backgroundColor: Colors.cyan,
        onPressed: () {
          User user = FirebaseAuth.instance.currentUser;
          Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Search(
                        currentUserId: user.uid,
                      )));
        },
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      body: ChatRoomTile(uid),
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final String uid;
  ChatRoomTile(this.uid);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              'Neelesh Singh',
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            subtitle: Text(
              'hello',
              style: TextStyle(fontSize: 14),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1565464027194-7957a2295fb7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=80'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
