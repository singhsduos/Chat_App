import 'dart:async';
import 'dart:io';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/Views/account_setting.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  SideDrawer({Key key}) : super(key: key);
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  AuthMethods authMethods = AuthMethods();
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Users users;
  bool isDarkTheme = false;
  SharedPreferences preferences;
  String username = '';
  String email = '';
  String createdAt = '';
  String photoUrl = '';
  String aboutMe = '';
  String id = '';
  File imageFileAvatar;

  @override
  void initState() {
    super.initState();
    readDataFromLocal();
  }

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
                        Icons.logout,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Log out',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Constants.prefs.setBool('userIsLoggedIn', false);
                  authMethods.signOut();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<MaterialPageRoute>(
                          builder: (BuildContext context) =>
                              Authenticate())); // Navigator.pop(context, 1);
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
                      'LOG OUT',
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
                      'CANCEL',
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
  Widget build(BuildContext context) {
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

    User user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                username,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                user.email,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  {
                    Navigator.push<MaterialPageRoute>(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => FullScreenImagePage(
                          url: photoUrl,
                        ),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Material(
                    child: photoUrl.toString() != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('images/placeHolder.jpg'),
                              )),
                              height: 80,
                              width: 80,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                            ),
                            imageUrl: photoUrl.toString(),
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 60.0,
                            color: Colors.white,
                          ),
                    borderRadius: BorderRadius.all(Radius.circular(125.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Colors.cyan),
            ),
            Container(
              child: InkWell(
                splashColor: Colors.cyan,
                onTap: () {
                  Navigator.push<MaterialPageRoute>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Settings()));
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    trailing: Icon(Icons.edit),
                    title: Text('Account Settings',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        )),
                    subtitle: Text('Personal',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        )),
                  ),
                ),
              ),
            ),
            Container(
              child: Consumer<ThemeNotifier>(
                builder: (BuildContext context, ThemeNotifier notifier,
                        Widget child) =>
                    InkWell(
                  splashColor: Colors.cyan,
                  child: SwitchListTile(
                    secondary: const Icon(Icons.nights_stay),
                    title: const Text('Dark theme',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        )),
                    subtitle:
                        const Text('Reduce glare and improve night viewing',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            )),
                    value: isDarkTheme,
                    activeTrackColor: Colors.blueGrey,
                    activeColor: Colors.cyan,
                    onChanged: (bool value) {
                      setState(
                        () {
                          isDarkTheme = value;
                          if (!value) {
                            _changeTheme(context, MyThemeKeys.LIGHT);
                          } else {
                            _changeTheme(context, MyThemeKeys.DARK);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: InkWell(
                splashColor: Colors.cyan,
                onTap: () {
                  openDialog();
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
