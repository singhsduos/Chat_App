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
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();
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

    usernameTextEditingController = TextEditingController(
      text: username,
    );
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
                      RawMaterialButton(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15.0),
                        elevation: 2.0,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        fillColor: Colors.cyan,
                        splashColor: Colors.transparent,
                        onPressed: getImage,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),
              //Input fields
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child:
                        isLoading ? CircularProgressIndicator() : Container(),
                  ),
                  //Username
                  Container(
                    alignment: Alignment.topLeft,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      trailing: Icon(
                        Icons.edit,
                        color: Colors.cyan,
                      ),
                      title: Text(
                        'Profile Name: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20),
                      ),

                      //username
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: "Your Username",
                          // contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                              fontSize: 17),
                        ),
                        controller: usernameTextEditingController,
                        onChanged: (value) {
                          username = value;
                        },
                        focusNode: usernameFocusNode,
                      ),
                    ),
                    //  margin: EdgeInsets.only(right: 0.0),
                  ),
                  // aboutMe -userBio
                  Container(
                    alignment: Alignment.topLeft,
                    child: ListTile(
                      leading: Icon(Icons.error_outline_outlined),
                      trailing: Icon(
                        Icons.edit,
                        color: Colors.cyan,
                      ),
                      title: Text(
                        'My Bio: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20),
                      ),

                      //username
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: "Tell about yourself",
                          // contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                              fontSize: 17),
                        ),
                        controller: aboutMeTextEditingController,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: aboutMeFocusNode,
                      ),
                    ),
                    //  margin: EdgeInsets.only(right: 0.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              //update Button
              SizedBox(
                height: 40,
              ),
              InkWell(
                // splashColor: Colors.blue,
                highlightColor: Colors.transparent,
                onTap: () => print('clicked'),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/3.0,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xfff4BCFFA),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Text('Update',
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
