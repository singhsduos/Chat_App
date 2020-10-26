import 'package:ChatApp/Views/chatView/widget/last_message.dart';
import 'package:ChatApp/Views/chatView/widget/online_indicator.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Widget/customTile.dart';
import 'package:ChatApp/Widget/fullScreenUserImage.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/Widget/photoCard.dart';
import 'package:ChatApp/modal/contacts.dart';
import 'package:ChatApp/modal/message.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/utils/call_utilities.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListView extends StatelessWidget {
  final Contact contact;
  final DatabaseMethods _authenticationMethods = DatabaseMethods();

  ChatListView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: _authenticationMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Users user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: Container(),
        );
      },
    );
  }
}

class ViewLayout extends StatefulWidget {
  final Users contact;
  ViewLayout({
    @required this.contact,
  });

  @override
  _ViewLayoutState createState() => _ViewLayoutState(contact: contact);
}

class _ViewLayoutState extends State<ViewLayout> {
  final Users contact;
  _ViewLayoutState({
    @required this.contact,
  });
  final DatabaseMethods _chatMethods = DatabaseMethods();

  Users sender;

  DatabaseMethods databaseMethods = DatabaseMethods();

  AuthMethods authMethods = AuthMethods();

  String iD;

  String _currentUserId;

  SharedPreferences preferences;

  Users _users;

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isDarkTheme = false;

  String username = '';

  String email = '';

  String createdAt = '';

  String photoUrl = '';

  String aboutMe = '';

  String id = '';

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
        sender = Users(
          userId: user.uid,
          username: username,
          photoUrl: photoUrl,
          email: user.email,
          aboutMe: aboutMe,
          createdAt: createdAt,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    Message _message;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<MaterialPageRoute>(
          builder: (context) => ConversationScreen(
            recevier: widget.contact,
          ),
        ),
      ),
      child: CustomTile(
        leading: GestureDetector(
          onTap: () => showDialog<Widget>(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              url: contact.photoUrl != null
                  ? contact.photoUrl
                  : 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
              title: Text(
                (widget.contact != null ? widget.contact.username : null) !=
                        null
                    ? widget.contact.username
                    : '..',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Arial",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    wordSpacing: 1.0),
              ),
              icon1: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.cyan,
                  size: 27,
                ),
                onPressed: () {
                  Navigator.push<MaterialPageRoute>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UserDetails(recevier: widget.contact)));
                },
              ),
              icon2: IconButton(
                icon: Icon(
                  Icons.video_call,
                  color: Colors.cyan,
                  size: 27,
                ),
                onPressed: () async =>
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dial(
                            from: sender,
                            to: contact,
                            context: context,
                            callis: "video")
                        : () {},
              ),
              icon3: IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.cyan,
                  size: 27,
                ),
                onPressed: () async =>
                    await Permissions.microphonePermissionsGranted()
                        ? CallUtils.dialVoice(
                            from: sender,
                            to: widget.contact,
                            context: context,
                            callis: "audio")
                        : () {},
              ),
              icon4: IconButton(
                icon: Icon(
                  Icons.chat,
                  color: Colors.cyan,
                  size: 27,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<MaterialPageRoute>(
                    builder: (context) => ConversationScreen(
                      recevier: widget.contact,
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.cyan, width: 2),
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ]),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: Material(
                child: widget.contact.photoUrl != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('images/placeHolder.jpg'),
                          )),
                          height: 80,
                          width: 80,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        ),
                        errorWidget: (context, url, dynamic error) => Material(
                          child: Image.asset(
                            'images/placeHolder.jpg',
                            width: 200.0,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: widget.contact.photoUrl,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: AssetImage('images/placeHolder.jpg'),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(125.0)),
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
        ),
        //  mini: false,
        title: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<MaterialPageRoute>(
              builder: (context) => ConversationScreen(
                recevier: widget.contact,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (widget.contact != null ? widget.contact.username : null) !=
                        null
                    ? widget.contact.username
                    : '..',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Arial",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    wordSpacing: 1.0),
              ),
              Container(
                child: LastMessageTimeContainer(
                  stream: _chatMethods.fetchLastMessageBetween(
                    id: userProvider.getUser.userId,
                    receiverId: widget.contact.userId,
                  ),
                ),
              )
            ],
          ),
        ),
        subtitle: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<MaterialPageRoute>(
              builder: (context) => ConversationScreen(
                recevier: widget.contact,
              ),
            ),
          ),
          child: Container(
            child: LastMessageContainer(
              stream: _chatMethods.fetchLastMessageBetween(
                id: userProvider.getUser.userId,
                receiverId: widget.contact.userId,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
