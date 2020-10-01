import 'dart:async';
import 'dart:io';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:ChatApp/Views/chatRoomsScreen.dart';

import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ConversationScreen extends StatelessWidget {
  final String chatRoomid;
  final String recevierAvatar;
  final String recevierName;
  const ConversationScreen(
      {Key key, this.chatRoomid, this.recevierAvatar, this.recevierName});

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: CachedNetworkImageProvider(recevierAvatar),
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 27,
          ),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute<MaterialPageRoute>(
                  builder: (BuildContext context) => ChatRoom(
                        uid: user.uid,
                      ))),
        ),
        title: Align(
          alignment: Alignment.center,
          child: Container(
            child: Text(
              recevierName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 21,
                letterSpacing: 1.5,
              ),
              //  textAlign: TextAlign.right
            ),
          ),
        ),
      ),
      body: ChatScreen(chatRoomid: chatRoomid, recevierAvatar: recevierAvatar),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatRoomid;
  final String recevierAvatar;

  ChatScreen(
      {Key key, @required this.chatRoomid, @required this.recevierAvatar})
      : super(key: key);

  @override
  _ChatScreen createState() =>
      _ChatScreen(chatRoomid: chatRoomid, recevierAvatar: recevierAvatar);
}

class _ChatScreen extends State<ChatScreen> {
  final String chatRoomid;
  final String recevierAvatar;

  _ChatScreen(
      {Key key, @required this.chatRoomid, @required this.recevierAvatar});

  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthMethods authMethods = AuthMethods();
  TextEditingController messageController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  bool isDisplaySticker = false;
  bool isLoading;
  bool isWriting = false;
  File imageFile;
  String imageUrl;
  String chatId;
  String id;
  dynamic listMessage;
  SharedPreferences preferences;

  Stream<QuerySnapshot> chatMessagesStream;

  // Widget ChatMessageList() {
  //   return StreamBuilder(
  //     stream: chatMessagesStream,
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       return snapshot.hasData
  //           ? ListView.builder(
  //               // ignore: prefer_const_literals_to_create_immutables
  //               itemCount: (int.parse('${snapshot.data.documents.length}')),
  //               itemBuilder: (context, index) {
  //                 return MessageTile(
  //                   '${snapshot.data.documents[index].data["message"]}',
  //                   Constants.myName ==
  //                       snapshot.data.documents[index].data["sendBy"],
  //                 );
  //               })
  //           : Container();
  //     },
  //   );
  // }

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
    // isDisplaySticker = false;
    isLoading = false;
    chatId = "";
    readLocal();

    databaseMethods
        .getConversationMessages(widget.chatRoomid)
        .then((dynamic value) {
      setState(() {
        chatMessagesStream = value as Stream<QuerySnapshot>;
      });
    });
    super.initState();
  }

  void readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id') ?? "";
    if (id.hashCode <= chatRoomid.hashCode) {
      chatId = '$id-$chatRoomid';
    } else {
      chatId = '$chatRoomid-$id';
    }
    // ignore: always_specify_types
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(<String, dynamic>{'chattingWith': chatRoomid});
    setState(() {});
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  dynamic hideEmojiContainer() {
    setState(() {
      isDisplaySticker = false;
    });
  }

  dynamic showEmojiContainer() {
    setState(() {
      isDisplaySticker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Flexible(
            child: createMessageList(),
          ),

          isDisplaySticker ? emojiContainer() : Container(),
          // if (isDisplaySticker) Container(child: emojiContainer()) else Container(),
          createInput(),
        ],
      ),
    );
  }

  Widget createMessageList() {
    return Expanded(
      child: chatId == ""
          ? Container()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('message')
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy('timestamp:', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    // itemBuilder: (context,index) => createItem(index,snapshot.data.document[index]),
                    itemCount: int.parse('${snapshot.data.documents.length}'),

                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }


    void displayBottomSheet(BuildContext context) {
    showModalBottomSheet<dynamic>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        barrierColor: ThemeData.dark().primaryColor.withOpacity(0.9),
        builder: (ctx) {
           return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.cyan,
      rows: 4,
      columns: 8,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        messageController.text = messageController.text + emoji.emoji;
      },
      recommendKeywords: ['face', 'happy', 'party', 'sad'],
      numRecommended: 50,
    );
        });
  }

  Widget emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.cyan,
      rows: 4,
      columns: 8,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        messageController.text = messageController.text + emoji.emoji;
      },
      recommendKeywords: ['face', 'happy', 'party', 'sad'],
      numRecommended: 50,
    );
  }

  Widget createInput() {
    return Container(
      padding: EdgeInsets.all(5),

      alignment: Alignment.bottomCenter,
      // height: MediaQuery.of(context).size.height,

      child: Row(
        children: <Widget>[
          //image sender icon
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(
                  Icons.image,
                  size: 30,
                ),
                color: Color(0xfff99AAAB),
                onPressed: getImage,
              ),
            ),
            color: Colors.transparent,
          ),

          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: messageController,
                  focusNode: focusNode,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                      color: Colors.white, letterSpacing: 1.0, fontSize: 17),
                  cursorColor: Colors.cyan,
                  cursorWidth: 3,
                  // cursorHeight: 5,
                  decoration: InputDecoration(
                    fillColor: Color(0xfff99AAAB),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Colors.white60,
                    ),
                    filled: true,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  color: Colors.white60,
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    if (!isDisplaySticker) {
                      showEmojiContainer();
                      hideKeyboard();
                    } else {
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                ),
              ],
            ),
          ),
          Material(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 0.0),
              child: RawMaterialButton(
                shape: CircleBorder(),
                padding: EdgeInsets.all(15.0),
                elevation: 2.0,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                fillColor: Colors.cyan,
                splashColor: Colors.transparent,
                onPressed: () => onSendMessage(messageController.text, 0),
              ),
            ),
            // color: Colors.cyan,
          ),
        ],
      ),
    );
  }

  void onSendMessage(String contentMsg, int type) {
    if (contentMsg != "") {
      messageController.clear();
      var docRef = FirebaseFirestore.instance
          .collection('message')
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          docRef,
          <String, dynamic>{
            'idFrom': id,
            'idTo': chatRoomid,
            'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': contentMsg,
            'type': type,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Please type a message', gravity: ToastGravity.CENTER);
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
    }
    uploadImageFile();
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Chat Images').child(fileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((dynamic downlodUrl) {
      imageUrl = downlodUrl.toString();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (String error) {
      setState(() {
        Fluttertoast.showToast(
          msg: "Error: " + error,
          textColor: Color(0xFFFFFFFF),
          backgroundColor: Colors.cyan,
          fontSize: 16.0,
          timeInSecForIosWeb: 3,
        );
        isLoading = false;
      });
    });
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
