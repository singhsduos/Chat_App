import 'package:ChatApp/Views/search.dart';
import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ChaTooApp',
          style: TextStyle(
            fontSize: 17.0,
            fontFamily: 'UncialAntiqua',
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        actions: [
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
      floatingActionButton:  FloatingActionButton(
       onPressed: (){ 
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
