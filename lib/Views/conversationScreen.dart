import 'dart:async';
import 'dart:io';
import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Widget/fullScreenGalleryImage.dart';
import 'package:ChatApp/Widget/fullScreenUserImage.dart';
import 'package:ChatApp/enum/view_state.dart';
import 'package:ChatApp/modal/message.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/image_upload_provider.dart';
import 'package:ChatApp/utils/call_utilities.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:ChatApp/Views/chatRoomsScreen.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationScreen extends StatefulWidget {
  final Users recevier;
  const ConversationScreen({Key key, this.recevier});

  @override
  _ConversationScreenState createState() => _ConversationScreenState(
        recevier: recevier,
      );
}

class _ConversationScreenState extends State<ConversationScreen> {
  Users sender;
  final Users recevier;
  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthMethods authMethods = AuthMethods();

  String iD;
  String _currentUserId;

  SharedPreferences preferences;
  _ConversationScreenState({
    Key key,
    @required this.recevier,
  });
  Users _users;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Users users;
  bool isDarkTheme = false;

  String username = '';
  String email = '';
  String createdAt = '';
  String photoUrl = '';
  String aboutMe = '';
  String id = '';
  File imageFileAvatar;

  Future readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    photoUrl = preferences.getString('photoUrl');
    username = preferences.getString('username');
    email = preferences.getString('email');
    aboutMe = preferences.getString('aboutMe');
    createdAt = preferences.getString('createdAt');
    id = preferences.getString('id');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readDataFromLocal();

    databaseMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender =
            Users(userId: user.uid, username: username, photoUrl: photoUrl);
      });
    });
  }

  // @override
  // Future<void> dispose() async {

  //   databaseMethods.getCurrentUser().then((user) {
  //     _currentUserId = user.uid;
  //     setState(() {
  //       sender =
  //           Users(userId: user.uid, username: username, photoUrl: photoUrl);
  //     });
  //   });
  //   super.dispose();
  // }

  Future<Null> openDialog() async {
    switch (await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.all(16),
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
                onPressed: () async =>
              await Permissions.microphonePermissionsGranted()
                  ? CallUtils.dialVoice(
                       from: sender,
                            to: widget.recevier,
                            context: context,
                      callis: "audio")
                  : {dynamic},
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
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dial(
                            from: sender,
                            to: widget.recevier,
                            context: context,
                            callis: "video"
                          )
                        : {dynamic},
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
    return PickupLayout(
          scaffold: Scaffold(
        appBar: homepageHeader(context),
        body: ChatScreen(
          recevier: recevier,
        ),
      ),
    );
  }

  User user = FirebaseAuth.instance.currentUser;
  AppBar homepageHeader(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.cyan,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push<MaterialPageRoute>(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UserDetails(recevier: widget.recevier)));
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Material(
                child: widget.recevier.photoUrl.toString() != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('images/placeHolder.jpg'),
                          )),
                          height: 40,
                          width: 40,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        ),
                        imageUrl: '${widget.recevier.photoUrl}',
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
      centerTitle: false,
      title: GestureDetector(
        onTap: () {
          Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => UserDetails(
                        recevier: widget.recevier,
                      )));
        },
        child: Text(
          widget.recevier.username,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
            letterSpacing: 1.5,
          ),
          // textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Users recevier;

  ChatScreen({Key key, @required this.recevier}) : super(key: key);

  @override
  _ChatScreen createState() => _ChatScreen(
        recevier: recevier,
      );
}

class _ChatScreen extends State<ChatScreen> {
  final Users recevier;

  _ChatScreen({
    Key key,
    @required this.recevier,
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
  String id;
  String iD;
  Users sender;
  String _currentUserId;
  List<QueryDocumentSnapshot> listMessage = new List.from(<String>[]);
  ImageUploadProvider _imageUploadProvider;

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

  @override
  void initState() {
    super.initState();
    databaseMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = Users(
          userId: user.uid,
          username: user.displayName,
          photoUrl: user.photoURL,
        );
      });
    });

    isLoading = false;

    imageUrl = '';
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
        .update(<String, dynamic>{'chattingWith': widget.recevier.userId});
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
        body: Column(
          children: <Widget>[
            // List of messages
            Flexible(child: messageList()),

            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    child: CircularProgressIndicator(),
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                  )
                : Container(),

            createInput(),

            isDisplaySticker ? Container(child: emojiContainer()) : Container(),
          ],
        ),

        // Loading
      );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(_currentUserId)
          .collection(widget.recevier.userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            controller: listScrollController,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.docs[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Container(
        alignment: _message.id == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.id == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(15);
    return Container(
      // margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: message.type != 'image'
            ? EdgeInsets.all(10)
            : EdgeInsets.symmetric(horizontal: 1, vertical: 5),
        child: getMessage(message),
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(15);
    return Container(
      // margin: EdgeInsets.only(top: 0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: BoxDecoration(
        color: Color(0xFFF99AAAB),
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
          padding: message.type != 'image'
              ? EdgeInsets.all(10)
              : EdgeInsets.symmetric(horizontal: 1, vertical: 5),
          child: getMessage(message)),
    );
  }

  Widget getMessage(Message message) {
    return message.type != 'image'
        ? Text(
            message.message,
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          )
        : Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 75),
                    decoration: BoxDecoration(
                      color: message.id == _currentUserId
                          ? Colors.cyan
                          : Color(0xFFF99AAAB),
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
                  imageUrl: message.photoUrl,
                  width: 300.0,
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
                        iD: message.id == _currentUserId
                            ? 'You'
                            : widget.recevier.username,
                        url: message.photoUrl,
                      ),
                    ));
              },
            ),
            margin: EdgeInsets.all(0),
          );
  }

  Widget emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.cyan,
      rows: 3,
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
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(5),
// height: MediaQuery.of(context).size.height*0.09,
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          //image sender icon
          GestureDetector(
            onTap: () => _settingModalBottomSheet(context),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.cyan],
                  ),
                  shape: BoxShape.circle),
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 6,
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
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
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
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 0.0),
            child: RawMaterialButton(
              shape: CircleBorder(),
              padding: EdgeInsets.all(13.0),
              elevation: 2.0,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              fillColor: Colors.cyan,
              splashColor: Colors.transparent,
              onPressed: () => onSendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  void onSendMessage() {
    var text = messageController.text;

    if (text.trim() != '') {
      Message _message = Message(
        recevierId: widget.recevier.userId,
        id: sender.userId,
        message: text,
        timestamp: DateTime.now().toString(),
        type: 'text',
      );
      setState(() {
        isWriting = false;
      });
      messageController.text = '';
      databaseMethods.addConversationMessages(_message, sender, recevier);
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
        throw ('File is not available');
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
    _imageUploadProvider.setToLoading();
    print('File Sended');
    storageTaskSnapshot.ref.getDownloadURL().then((dynamic downlodUrl) {
      imageUrl = '$downlodUrl';
      setState(() {
        _imageUploadProvider.setToIdle();

        sendImage(imageUrl);
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

  Future<void> sendImage(String picUrl) async {
    Message _message;
    _message = Message.imageMessage(
      message: 'IMAGE',
      recevierId: widget.recevier.userId,
      id: sender.userId,
      photoUrl: picUrl,
      timestamp: DateTime.now().toString(),
      type: 'image',
    );
    var map = _message.toImageMap() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(_message.id)
        .collection(_message.recevierId)
        .add(map);

    return await FirebaseFirestore.instance
        .collection('messages')
        .doc(_message.recevierId)
        .collection(_message.id)
        .add(map);
  }
}
