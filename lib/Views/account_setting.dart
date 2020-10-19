import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 27,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
      ),
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
  String id = '';
  File imageFileAvatar;
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    id = preferences.getString('id');

    usernameTextEditingController = TextEditingController(
      text: username,
    );
    aboutMeTextEditingController = TextEditingController(text: aboutMe);

    setState(() {});
  }

  final picker = ImagePicker();

  Future getImage() async {
    final newImagefile = await picker.getImage(source: ImageSource.gallery);
    final ScaffoldState scaffold = _scaffoldKey.currentState;
    try {
      if (newImagefile != null) {
        setState(() {
          this.imageFileAvatar = File(newImagefile.path);
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
    uploadImageToFirestoreAndStorage();
  }

  Future cameraImage() async {
    final newImagefile = await picker.getImage(source: ImageSource.camera);

    if (newImagefile != null) {
      setState(() {
        this.imageFileAvatar = File(newImagefile.path);
        isLoading = true;
      });
    }
    uploadImageToFirestoreAndStorage();
  }

  Future<void> _settingModalBottomSheet(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.cyan,
            padding: EdgeInsets.only(bottom: 10.0, top: 16.0),
            child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Profile photo',
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5.0,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: IconButton(
                                    onPressed: cameraImage,
                                    icon: Icon(
                                      Icons.camera,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 10.0),
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: IconButton(
                                    onPressed: getImage,
                                    icon: Icon(
                                      Icons.image,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 10.0),
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: IconButton(
                                    onPressed: () {
                                      openDialog(context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(right: 10.0),
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Null> openDialog(BuildContext context) async {
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
                        Icons.delete,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Delete profile picture?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
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
                          'CANCEL',
                          style: TextStyle(
                              color: Colors.cyan, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      deletePicture();
                      context:
                      context;
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.cyan,
                          ),
                          margin: EdgeInsets.only(right: 10.0),
                        ),
                        Text(
                          'DELETE',
                          style: TextStyle(
                              color: Colors.cyan, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
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

  Future<void> deletePicture() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(<String, dynamic>{'photoUrl': null}).then((data) async {
      await preferences.setString('photoUrl', null);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'Picture deleted successfully.', gravity: ToastGravity.CENTER);
    });
  }

  Future uploadImageToFirestoreAndStorage() async {
    String mFileName = basename(imageFileAvatar.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('uploadsImages/$mFileName');
    StorageUploadTask storageUploadTask =
        storageReference.putFile(imageFileAvatar);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    print('File Uploaded');
    storageTaskSnapshot.ref.getDownloadURL().then((dynamic value) {
      photoUrl = '$value';

      // ignore: always_specify_types
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update(<String, String>{
        'photoUrl': photoUrl,
        'aboutMe': aboutMe,
        'username': username,
      }).then((data) async {
        await preferences.setString('photoUrl', photoUrl);
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Picture updated successfully.', gravity: ToastGravity.CENTER);
      });
    }, onError: (Object errorMsg) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: errorMsg.toString(), gravity: ToastGravity.CENTER);
    });
  }

  void updateData() {
    usernameFocusNode.unfocus();
    aboutMeFocusNode.unfocus();
    setState(() {
      isLoading = false;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(<String, String>{
      'photoUrl': photoUrl,
      'aboutMe': aboutMe,
      'username': username,
    }).then((data) async {
      await preferences.setString('photoUrl', photoUrl);
      await preferences.setString('aboutMe', aboutMe);
      await preferences.setString('username', username);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Profile updated successfully.');
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
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
                      if (imageFileAvatar == null)
                        GestureDetector(
                          onTap: () {
                            {
                              Navigator.push<MaterialPageRoute>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FullScreenImagePage(
                                          url: photoUrl != null
                                              ? photoUrl
                                              : 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg'),
                                ),
                              );
                            }
                          },
                          child: Material(
                            //displaying existing pic
                            child: photoUrl.toString() != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                            'images/placeHolder.jpg'),
                                      )),
                                      height: 200,
                                      width: 200,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                    ),
                                    imageUrl: photoUrl.toString(),
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 200.0,
                                    color: Colors.white,
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(125.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            {
                              Navigator.push<MaterialPageRoute>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FullScreenImagePage(
                                    url: ('${imageFileAvatar}'),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Material(
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
                        onPressed: () {
                          _settingModalBottomSheet(context);
                        },
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child:
                          isLoading ? CircularProgressIndicator() : Container(),
                    ),
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
                            // color: Colors.black87,
                            fontSize: 20),
                      ),

                      //username
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: "Your Username",
                          // contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              // color: Colors.black87,
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
                  // AboutMe -userBio
                  Container(
                    alignment: Alignment.topLeft,
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      trailing: Icon(
                        Icons.edit,
                        color: Colors.cyan,
                      ),
                      title: Text(
                        'My Bio: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black87,
                            fontSize: 20),
                      ),

                      //username
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: "Tell about yourself",
                          // contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              // color: Colors.black87,
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
                highlightColor: Colors.transparent,
                onTap: updateData,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 3.0,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
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
