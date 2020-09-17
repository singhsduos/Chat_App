import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Views/drawer.dart';
import 'package:ChatApp/Views/search.dart';
import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/helper/helperfunctions.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder<dynamic>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      '${snapshot.data.documents[index].data['chatroomid'].toString().replaceAll('_', "").replaceAll(Constants.myName, "")}, ${snapshot.data.documents[index].data['chatroomid']}');
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  dynamic getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((dynamic value) {
      setState(() {
        chatRoomsStream = value as Stream<dynamic>;
      });
    });

    setState(() {});
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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<MaterialPageRoute>(
                      builder: (BuildContext context) => Authenticate()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.cyan,
      ),
      drawer: SideDrawer(),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen()));
        },
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomid;
  ChatRoomTile(this.userName, this.chatRoomid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
                  context,
                  MaterialPageRoute<MaterialPageRoute>(
                      builder: (BuildContext context) => ConversationScreen(chatRoomid)));
            
      },
          child: Container(
            color: Color(0xfff99AAAB),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.cyan, borderRadius: BorderRadius.circular(40)),
              child: Text('${userName.substring(0, 1).toUpperCase()}'),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: TextStyle(
                  color: Colors.white, letterSpacing: 1.0, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
