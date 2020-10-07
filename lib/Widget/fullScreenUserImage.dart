import 'dart:io';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails extends StatelessWidget {
  final String recevierAvatar;
  final String recevierName;
  final String recevierId;
  final String recevierMail;
  final String recevierAbout;
  final String recevierCreate;
  const UserDetails(
      {Key key,
      this.recevierAvatar,
      this.recevierName,
      this.recevierId,
      this.recevierMail,
      this.recevierAbout,
      this.recevierCreate});

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.cyan),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              recevierName,
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
      body: UsersDetailsScreen(
        recevierId: recevierId,
        recevierAvatar: recevierAvatar,
        recevierName: recevierName,
        recevierMail: recevierMail,
        recevierAbout: recevierAbout,
        recevierCreate: recevierCreate,
      ),
    );
  }
}

class UsersDetailsScreen extends StatefulWidget {
  final String recevierId;
  final String recevierAvatar;
  final String recevierName;
  final String recevierMail;
  final String recevierAbout;
  final String recevierCreate;
  UsersDetailsScreen({
    Key key,
    @required this.recevierId,
    @required this.recevierAvatar,
    @required this.recevierName,
    @required this.recevierMail,
    @required this.recevierAbout,
    @required this.recevierCreate,
  }) : super(key: key);

  @override
  _UsersDetailsScreenState createState() => _UsersDetailsScreenState(
        recevierId: recevierId,
        recevierAvatar: recevierAvatar,
        recevierName: recevierName,
        recevierMail: recevierMail,
        recevierAbout: recevierAbout,
        recevierCreate: recevierCreate,
      );
}

class _UsersDetailsScreenState extends State<UsersDetailsScreen> {
  final String recevierId;
  final String recevierAvatar;
  final String recevierName;
  final String recevierMail;
  final String recevierAbout;
  final String recevierCreate;

  _UsersDetailsScreenState({
    Key key,
    @required this.recevierId,
    @required this.recevierAvatar,
    @required this.recevierName,
    @required this.recevierMail,
    @required this.recevierAbout,
    @required this.recevierCreate,
  });
  TextEditingController usernameTextEditingController;
  TextEditingController aboutMeTextEditingController;
  SharedPreferences preferences;

  File imageFileAvatar;
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            color: Color(0xfffecf0f1),
            child: Column(
              children: <Widget>[
                //profile pic
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Material(
                          child: recevierAvatar.toString() != null
                              ? GestureDetector(
                                  onTap: () {
                                    {
                                      Navigator.push<MaterialPageRoute>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FullScreenImagePage(
                                            url: '${recevierAvatar}',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                            'images/placeHolder.jpg'),
                                      )),
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                    ),
                                    imageUrl: '${recevierAvatar}',
                                    // width: 50.0,
                                    // height: 50.0,
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 2,

                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 200.0,
                                  color: Colors.cyan,
                                ),
                          // borderRadius: BorderRadius.all(Radius.circular(.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  // margin: EdgeInsets.all(20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                //fields
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'About me and email-Id',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                              fontSize: 20),
                        ),
                      ),
                      //Users About Me
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade300))),
                        alignment: Alignment.topLeft,
                        child: ListTile(
                          leading: Icon(Icons.info_outline,
                              color: Colors.cyan, size: 28),
                          title: Text(
                            '${recevierAbout ?? 'Not available'}',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                        ),
                        //  margin: EdgeInsets.only(right: 0.0),
                      ),
                      // Users-MailId
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade300))),

                        alignment: Alignment.topLeft,
                        child: ListTile(
                          leading: Icon(Icons.mail_outline,
                              color: Colors.cyan, size: 28),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.message,
                              color: Colors.cyan,
                              size: 28.0,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<MaterialPageRoute>(
                                      builder: (BuildContext context) =>
                                          ConversationScreen(
                                            recevierId: recevierId,
                                            recevierAvatar: recevierAvatar,
                                            recevierName: recevierName,
                                            recevierMail: recevierMail,
                                            recevierAbout: recevierAbout,
                                            recevierCreate: recevierCreate,
                                          )));
                            },
                          ),
                          title: Text(
                            '${recevierMail ?? 'Not available'}',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          ),

                          //username
                        ),
                        //  margin: EdgeInsets.only(right: 0.0),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                // Users Joined Date
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Joined At : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade300))),

                        alignment: Alignment.topLeft,
                        child: ListTile(
                          leading: Icon(
                            Icons.date_range,
                            color: Colors.cyan,
                            size: 28,
                          ),
                          title: Text(
                            DateFormat('dd MMMM, yyyy - hh:mm:aa').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(recevierCreate))),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                        //  margin: EdgeInsets.only(right: 0.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
