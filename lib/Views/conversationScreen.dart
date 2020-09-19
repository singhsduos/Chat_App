import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomid;
  ConversationScreen(this.chatRoomid);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthMethods authMethods = AuthMethods();
  TextEditingController messageController = TextEditingController();

  Stream<QuerySnapshot> chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                // ignore: prefer_const_literals_to_create_immutables
                itemCount: (int.parse('${snapshot.data.documents.length}')),
                itemBuilder: (context, index) {
                  return MessageTile(
                    '${snapshot.data.documents[index].data["message"]}',
                    Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  dynamic sendMessage() {
    if (messageController.text.isNotEmpty) {
      // ignore: always_specify_types
      final Map<String, dynamic> messageMap = <String, dynamic>{
        'message': messageController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomid, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    databaseMethods
        .getConversationMessages(widget.chatRoomid)
        .then((dynamic value) {
      setState(() {
        chatMessagesStream = value as Stream<QuerySnapshot>;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.0,
                                fontSize: 17),
                            cursorColor: Colors.cyan,
                            cursorWidth: 3,
                            // cursorHeight: 5,
                            decoration: InputDecoration(
                              suffixIcon: Container(
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white60,
                                ),
                              ),
                              fillColor: Color(0xfff99AAAB),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 2),
                              ),
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: Colors.white60,
                              ),
                              filled: true,
                              // labelStyle: new TextStyle(
                              // color: Color(0xfff99AAAB), fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe ? [Colors.cyan] : [const Color(0xfff99AAAB)],
            ),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: Text(
          message,
          style:
              TextStyle(color: Colors.white, letterSpacing: 1.0, fontSize: 17),
        ),
      ),
    );
  }
}
