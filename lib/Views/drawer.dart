import 'dart:io';
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
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
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
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Stack(
                    children: <Widget>[
                      (photoUrl == null)
                          ? Icon(
                            Icons.account_circle,
                            size: 60,
                            color: Colors.white,
                          )
                          : Material(
                              //displaying existing pic
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.cyan)),
                                ),
                                imageUrl: photoUrl,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            )
                    ],
                  ),
                ),

                //  (user.photoUrl==null)
                // ? AssetImage('images/placeHolder.jpg'):
                // CachedNetworkImageProvider(user.photoUrl),
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
              // decoration: BoxDecoration(
              //     border:
              //         Border(bottom: BorderSide(color: Colors.grey.shade400))),
            ),
            Container(
              child: Consumer<ThemeNotifier>(
                builder: (BuildContext context, ThemeNotifier notifier,
                        Widget child) =>
                    SwitchListTile(
                  secondary: const Icon(Icons.nights_stay),
                  title: const Text('Dark theme',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      )),
                  subtitle: const Text('Reduce glare and improve night viewing',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      )),
                  value: isDarkTheme,
                  activeTrackColor: Colors.blueGrey,
                  activeColor: Colors.cyan,
                  onChanged: (bool value) {
                    setState(() {
                      isDarkTheme = value;
                      if (!value) {
                        _changeTheme(context, MyThemeKeys.LIGHT);
                      } else {
                        _changeTheme(context, MyThemeKeys.DARK);
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              child: InkWell(
                splashColor: Colors.cyan,
                onTap: () {
                  Constants.prefs.setBool('userIsLoggedIn', false);
                  authMethods.signOut();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<MaterialPageRoute>(
                          builder: (BuildContext context) => Authenticate()));
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
              // decoration: BoxDecoration(
              //     border:
              //         Border(bottom: BorderSide(color: Colors.grey.shade400))),
            ),
          ],
        ),
      ),
    );
  }
}
