import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 27,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan,
        title: Text(
          'Account Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.white,
          ),

        ),
        centerTitle: true,
      ),
      body: SettingScreen(),
    );
  }
}

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController usernameTextEditingController;
  TextEditingController aboutMeTextEditingController;
  SharedPreferences preferences;
  String username = '';
  String email = '';
  String createdAt = '';
  String photoUrl = '';
  String aboutMe = '';
  File imageFileAvatar;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    readDataFromLocal();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    photoUrl = preferences.getString('photoUrl');
    username = preferences.getString('username');
    email = preferences.getString('email');
    aboutMe = preferences.getString('aboutMe');
    createdAt = preferences.getString('createdAt');

    usernameTextEditingController = TextEditingController(text: username);
    aboutMeTextEditingController = TextEditingController(text: aboutMe);

    setState(() {});
  }

  Future getImage() async {
    File newImagefile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (newImagefile != null) {
      setState(() {
        this.imageFileAvatar = newImagefile;
        isLoading = true;
      });
    }
    // uploadImageToFirestoreAndStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //profile pic
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imageFileAvatar == null)
                          ? (photoUrl != "")
                              ? Material(
                                  //displaying existing pic
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.cyan)),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(125.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90,
                                  color: Color(0xfff99AAAB),
                                )
                          : Material(
                              child: Image.file(
                                imageFileAvatar,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(125.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 50.0,
                          color: Color(0xfff99AAAB),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 200.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              )
            ],
          ),
        )
      ],
    );
  }
}
