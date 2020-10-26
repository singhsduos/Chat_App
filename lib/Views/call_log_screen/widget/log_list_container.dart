import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Widget/customTile.dart';
import 'package:ChatApp/Widget/fullScreenUserImage.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/Widget/photoCard.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:ChatApp/helper/strings.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/services/repository_log/log_repository.dart';
import 'package:ChatApp/utils/call_utilities.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  Call call;

  Widget getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.cyan,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.greenAccent,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  Users sender;

  final DatabaseMethods _chatMethods = DatabaseMethods();

  String _currentUserId;
  String username = '';
  String email = '';
  String createdAt = '';
  String photoUrl = '';
  String aboutMe = '';
  String id = '';
  SharedPreferences preferences;
  String currentUserId;
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<Users> userList;
  String query = '';

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

    _chatMethods.getCurrentUser().then((user) {
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
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data as List<dynamic>;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i] as Log;
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

                return CustomTile(
                  leading: GestureDetector(
                    onTap: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        url: (hasDialled ? _log.receiverPic : _log.callerPic),
                        title: Text(
                          hasDialled
                              ? _log?.receiverName ?? ".."
                              : _log?.callerName ?? "..s",
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
                                builder: (BuildContext context) => UserDetails(
                                  recevier: Users(
                                    username: hasDialled
                                        ? _log.receiverName
                                        : _log.callerName,
                                    photoUrl: hasDialled
                                        ? _log.receiverPic
                                        : _log.callerPic,
                                    userId: hasDialled
                                        ? _log.receiverId
                                        : _log.callerId,
                                    email: hasDialled
                                        ? _log.receiverEmail
                                        : _log.callerEmail,
                                    createdAt: hasDialled
                                        ? _log.receiverCreatedAt
                                        : _log.callerCreatedAt,
                                    aboutMe: hasDialled
                                        ? _log.receiverAboutMe
                                        : _log.callerAboutMe,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        icon2: IconButton(
                          icon: Icon(
                            Icons.video_call,
                            color: Colors.cyan,
                            size: 27,
                          ),
                          onPressed: () async => await Permissions
                                  .cameraAndMicrophonePermissionsGranted()
                              ? CallUtils.dial(
                                  from: sender,
                                  to: Users(
                                    username: hasDialled
                                        ? _log.receiverName
                                        : _log.callerName,
                                    photoUrl: hasDialled
                                        ? _log.receiverPic
                                        : _log.callerPic,
                                    userId: hasDialled
                                        ? _log.receiverId
                                        : _log.callerId,
                                    email: hasDialled
                                        ? _log.receiverEmail
                                        : _log.callerEmail,
                                    createdAt: hasDialled
                                        ? _log.receiverCreatedAt
                                        : _log.callerCreatedAt,
                                    aboutMe: hasDialled
                                        ? _log.receiverAboutMe
                                        : _log.callerAboutMe,
                                  ),
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
                                      to: Users(
                                        username: hasDialled
                                            ? _log.receiverName
                                            : _log.callerName,
                                        photoUrl: hasDialled
                                            ? _log.receiverPic
                                            : _log.callerPic,
                                        userId: hasDialled
                                            ? _log.receiverId
                                            : _log.callerId,
                                        email: hasDialled
                                            ? _log.receiverEmail
                                            : _log.callerEmail,
                                        createdAt: hasDialled
                                            ? _log.receiverCreatedAt
                                            : _log.callerCreatedAt,
                                        aboutMe: hasDialled
                                            ? _log.receiverAboutMe
                                            : _log.callerAboutMe,
                                      ),
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
                                recevier: Users(
                                  username: hasDialled
                                      ? _log.receiverName
                                      : _log.callerName,
                                  photoUrl: hasDialled
                                      ? _log.receiverPic
                                      : _log.callerPic,
                                  userId: hasDialled
                                      ? _log.receiverId
                                      : _log.callerId,
                                  email: hasDialled
                                      ? _log.receiverEmail
                                      : _log.callerEmail,
                                  createdAt: hasDialled
                                      ? _log.receiverCreatedAt
                                      : _log.callerCreatedAt,
                                  aboutMe: hasDialled
                                      ? _log.receiverAboutMe
                                      : _log.callerAboutMe,
                                ),
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
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Material(
                          child: (hasDialled
                                      ? _log.receiverPic
                                      : _log.callerPic) !=
                                  null
                              ? CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image:
                                          AssetImage('images/placeHolder.jpg'),
                                    )),
                                    height: 80,
                                    width: 80,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                  ),
                                  errorWidget: (context, url, dynamic error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/placeHolder.jpg',
                                      width: 200.0,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: (hasDialled
                                      ? _log.receiverPic
                                      : _log.callerPic),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(125.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ),
                    ),
                  ),
                  mini: false,
                  onLongPress: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                      title: Center(
                        child: Text(
                          "Delete this Log?",
                        ),
                      ),
                      content: Text(
                        "Are you sure you wish to delete this log?",
                        style: TextStyle(color: Colors.cyan),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "NO",
                            style: TextStyle(color: Colors.cyan),
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        FlatButton(
                          child: Text(
                            "YES",
                            style: TextStyle(color: Colors.cyan),
                          ),
                          onPressed: () async {
                            Navigator.maybePop(context);
                            await LogRepository.deleteLogs(i);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    hasDialled
                        ? _log?.receiverName ?? ".."
                        : _log?.callerName ?? "..s",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  icon: getIcon(_log.callStatus),
                  subtitle: Text(
                    DateFormat("dd MMM yyyy - hh:mm aa").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(_log.timestamp))),
                    style: TextStyle(
                      fontSize: 13,
                      // color: Colors.white,
                    ),
                  ),
                  // trailing: call.isCall == 'audio'
                  //     ? Icon(Icons.call)
                  //     : Icon(Icons.video_call),
                );
              },
            );
          }
          return QuietBox(
            heading: 'This is where all your call logs are listed.',
          );
        }
        return QuietBox(
          heading: 'This is where all your call logs are listed.',
        );
      },
    );
  }
}
