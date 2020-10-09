import 'dart:async';
import 'dart:io';
import 'package:ChatApp/Widget/fullScreenGalleryImage.dart';
import 'package:ChatApp/Widget/fullScreenUserImage.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/utils/call_utilities.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationScreen extends StatefulWidget {
  final String recevierId;
  final String recevierAvatar;
  final String recevierName;
  final String recevierMail;
  final String recevierAbout;
  final String recevierCreate;
  const ConversationScreen(
      {Key key,
      this.recevierId,
      this.recevierAvatar,
      this.recevierName,
      this.recevierMail,
      this.recevierAbout,
      this.recevierCreate});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Users sender;

  Users recevier;
  Future<Null> openDialog() async {
    switch (await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: Colors.cyan,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.call,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Make calls to your friends',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.call,
                        color: Colors.cyan,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Internet Call',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () async =>
                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                  CallUtils.dial(
                    from: sender,
                    to: recevier,
                    context: context,
                  ) : {dynamic},
                
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.video_call,
                        color: Colors.cyan,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Video Call',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.cyan,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Users users;
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push<MaterialPageRoute>(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserDetails(
                              recevierAvatar: widget.recevierAvatar,
                              recevierName: widget.recevierName,
                              recevierMail: widget.recevierMail,
                              recevierAbout: widget.recevierAbout,
                              recevierCreate: widget.recevierCreate,
                            )));
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  widget.recevierName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    letterSpacing: 1.5,
                  ),
                  // textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push<MaterialPageRoute>(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => UserDetails(
                            recevierAvatar: widget.recevierAvatar,
                            recevierName: widget.recevierName,
                            recevierMail: widget.recevierMail,
                            recevierAbout: widget.recevierAbout,
                            recevierCreate: widget.recevierCreate,
                          )));
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Material(
                  child: widget.recevierAvatar.toString() != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('images/placeHolder.jpg'),
                            )),
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                          ),
                          imageUrl: widget.recevierAvatar.toString(),
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.call,
              color: Colors.white,
              size: 27,
            ),
            onPressed: openDialog,
          ),
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
        centerTitle: true,
      ),
      body: ChatScreen(
        recevierId: widget.recevierId,
        recevierAvatar: widget.recevierAvatar,
        recevierName: widget.recevierName,
        recevierMail: widget.recevierMail,
        recevierAbout: widget.recevierAbout,
        recevierCreate: widget.recevierCreate,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String recevierId;
  final String recevierAvatar;
  final String recevierName;
  final String recevierMail;
  final String recevierAbout;
  final String recevierCreate;

  ChatScreen({
    Key key,
    @required this.recevierId,
    @required this.recevierAvatar,
    @required this.recevierName,
    @required this.recevierMail,
    @required this.recevierAbout,
    @required this.recevierCreate,
  }) : super(key: key);

  @override
  _ChatScreen createState() => _ChatScreen(
        recevierId: recevierId,
        recevierAvatar: recevierAvatar,
        recevierName: recevierName,
        recevierMail: recevierMail,
        recevierAbout: recevierAbout,
        recevierCreate: recevierCreate,
      );
}

class _ChatScreen extends State<ChatScreen> {
  final String recevierId;
  final String recevierAvatar;
  final String recevierName;
  final String recevierMail;
  final String recevierAbout;
  final String recevierCreate;

  _ChatScreen({
    Key key,
    @required this.recevierId,
    @required this.recevierAvatar,
    @required this.recevierName,
    @required this.recevierMail,
    @required this.recevierAbout,
    @required this.recevierCreate,
  });

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
  List<QueryDocumentSnapshot> listMessage = new List.from(<String>[]);
  int _limit = 20;
  final int _limitIncrement = 20;
  SharedPreferences preferences;

  Future<void> _settingModalBottomSheet(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Gallery'),
                  onTap: getImage,
                ),
                new ListTile(
                  leading: new Icon(Icons.camera),
                  title: new Text('Camera'),
                  onTap: cameraImage,
                ),
              ],
            ),
          );
        });
  }

  void _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();

    listScrollController.addListener(_scrollListener);
    isLoading = false;
    chatId = "";
    imageUrl = '';
    readLocal();
  }

  void readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id') ?? '';
    if (id.hashCode <= recevierId.hashCode) {
      chatId = '$id-$recevierId';
    } else {
      chatId = '$recevierId-$id';
    }
    // ignore: always_specify_types
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(<String, dynamic>{'chattingWith': recevierId});
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

  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(<String, dynamic>{'chattingWith': null});
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              createMessageList(),

              createInput(),

              isDisplaySticker
                  ? Container(child: emojiContainer())
                  : Container(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child:
          isLoading ? Center(child: CircularProgressIndicator()) : Container(),
    );
  }
  // {
  //   return Scaffold(
  //     body: Container(
  //       child: Stack(
  //         children: <Widget>[
  //           Column(
  //             children: <Widget>[
  //               //create list of message
  //               createMessageList(),

  //               createInput(),

  //               isDisplaySticker
  //                   ? Container(child: emojiContainer())
  //                   : Container(),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget createMessageList() {
    return Flexible(
      child: chatId == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            )
          // Container()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('message')
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy('timestamp:', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    ),
                  );
                  // return Container();
                } else {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        createItem(index, snapshot.data.docs[index]),
                    itemCount: snapshot.data.docs.length,
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
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
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
          //Text and emoji msg type 0
          if (document.data()['type'] == 0)
            Container(
              child: Text(
                "${document.data()['content']}",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.cyan, borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(
                  bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
            )
          else
            Container(
              child: FlatButton(
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                      ),
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                    imageUrl: "${document.data()['content']}",
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
                      builder: (BuildContext context) => FullScreenGalleryImage(
                        url: "${document.data()['content']}",
                      ),
                    ),
                  );
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
                if (isLastMsgLeft(index))
                  Material(
                    //display reciever profile image
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
                        width: 35.0,
                        height: 35.0,
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
                else
                  Container(
                    width: 35.0,
                  ),
                //displayMsg

                if (document.data()['type'] == 0)
                  Container(
                    child: Text(
                      "${document.data()['content']}",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.0,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Color(0xfff99AAAB),
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  )
                else
                  Container(
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
                          imageUrl: "${document.data()['content']}",
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
                                  FullScreenGalleryImage(
                                url: "${document.data()['content']}",
                              ),
                            ));
                      },
                    ),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
              ],
            ),

            //receiver Msg time
            isLastMsgLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMMM,yyyy - hh:mm:aa')
                          .format(DateTime.now()),
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
    return Expanded(
      child: Container(
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
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                ),
              ),
              color: Colors.transparent,
            ),

            Flexible(
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
                  //emoji button
                  IconButton(
                    splashColor: Colors.transparent,
                    color: Colors.white60,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.emoji_emotions),
                    onPressed: () {
                      if (!isDisplaySticker) {
                        hideKeyboard();
                        showEmojiContainer();
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
      ),
    );
  }

  void onSendMessage(String contentMsg, int type) {
    if (contentMsg.trim() != "") {
      messageController.clear();
      var docRef = FirebaseFirestore.instance
          .collection('message')
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          docRef,
          <String, dynamic>{
            'idFrom': id,
            'idTo': recevierId,
            'timeStamp': DateTime.now(),
            'content': contentMsg,
            'type': type,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
      print('message sended');
    } else {
      Fluttertoast.showToast(
          msg: 'Please type a message', gravity: ToastGravity.CENTER);
    }
  }

  final picker = ImagePicker();

  Future getImage() async {
    final imageFileUpload = await picker.getImage(source: ImageSource.gallery);

    try {
      if (imageFileUpload != null) {
        setState(() {
          this.imageFile = File(imageFileUpload.path);
          isLoading = true;
        });
      } else {
        throw ('File is not available/not taken');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
          msg: e.toString(),
          textColor: Color(0xFFFFFFFF),
          fontSize: 16.0,
          // timeInSecForIosWeb: 4,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.cyan,
        );
      });
    }
    uploadImageFile();
  }

  Future cameraImage() async {
    final imageFileUpload = await picker.getImage(source: ImageSource.camera);

    if (imageFileUpload != null) {
      setState(() {
        this.imageFile = File(imageFileUpload.path);
        isLoading = true;
      });
    }
    uploadImageFile();
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('ChatImages/$fileName');
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    print('File Sended');
    storageTaskSnapshot.ref.getDownloadURL().then((dynamic downlodUrl) {
      imageUrl = '$downlodUrl';
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (Object error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error: " + error.toString(),
        textColor: Color(0xFFFFFFFF),
        backgroundColor: Colors.cyan,
        fontSize: 16.0,
        timeInSecForIosWeb: 3,
      );
    });
  }
}
