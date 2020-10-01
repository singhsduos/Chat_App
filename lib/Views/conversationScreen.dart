import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:ChatApp/Views/chatRoomsScreen.dart';

import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  @override
  void initState() {
    // isDisplaySticker = false;
    isLoading = false;
    chatId = "";
    readLocal();

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
          createMessageList(),

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
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context, index) =>
                        createItem(index, snapshot.data.docs[index]),
                    itemCount: int.parse('${snapshot.data.docs.length}'),
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget createItem(int index, DocumentSnapshot document) {
    //sender messages display-right side
    if (document.data()['idFrom'] == id) {
      return Row(
        children: <Widget>[
          document.data()["type"] == 0
              ? Container(
                  child: Text(
                    document.data()['content'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMsgRight(index) ? 20 : 10, right: 10.0),
                )
              //Image msg
              : Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.cyan),
                          ),
                          width: 200,
                          height: 200,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        errorWidget: (context, url, dynamic error) => Material(
                          child: Image.asset(
                            'images/no_image.jpg',
                            width: 200.0,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document.data()['content'].toString(),
                        width: 200.0,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
                      Navigator.push<MaterialPageRoute>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                FullScreenImagePage(
                                    url: document.data()['content'].toString()),
                          ));
                    },
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMsgRight(index) ? 20 : 10, right: 10.0),
                ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
    //reciever messages display-leftside
    else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMsgLeft(index)
                    ? Material(
                        //display reciever profile image
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.cyan),
                            ),
                            width: 35,
                            height: 35,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: recevierAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: 35.0,
                      ),
                //displayMsg
                document.data()["type"] == 0
                    //text msg
                    ? Container(
                        child: Text(
                          document.data()['content'].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200,
                        decoration: BoxDecoration(
                            color: Color(0xfff99AAAB),
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    //Image msg
                    : Container(
                        child: FlatButton(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.cyan),
                                ),
                                width: 200,
                                height: 200,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              errorWidget: (context, url, dynamic error) =>
                                  Material(
                                child: Image.asset(
                                  'images/no_image.jpg',
                                  width: 200.0,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document.data()['content'].toString(),
                              width: 200.0,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push<MaterialPageRoute>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FullScreenImagePage(
                                          url: document
                                              .data()['content']
                                              .toString()),
                                ));
                          },
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      ),
              ],
            ),

            //Msg time
            isLastMsgLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMMM,yyyy - hh:mm:aa').format(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                              document.data()['timestamp'].toString()))),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0))
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
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
              children: <Widget>[
                TextField(
                  controller: messageController,
                  focusNode: focusNode,
                  onTap: () => hideEmojiContainer(),

                  style: TextStyle(
                      color: Colors.white, letterSpacing: 1.0, fontSize: 17),
                  cursorColor: Colors.cyan,
                  cursorWidth: 3,
                  // onChanged: (val) {
                  //   (val.length > 0 && val.trim() != "")
                  //       ? setWritingTo(true)
                  //       : setWritingTo(false);
                  // },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.white60,
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: Color(0xfff99AAAB),
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
