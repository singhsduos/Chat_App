import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool isDarkTheme = false;
  SharedPreferences preferences;
  String username = '';
  String email = '';
  String createdAt = '';
  String photoUrl = '';
  String aboutMe = '';
  File imageFileAvatar;
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

    // void _initPrefs() async {
    //   if (prefs == null) prefs = await SharedPreferences.getInstance();
    // }

    // void _loadfromPrefs() async {
    //   await _initPrefs();
    //   _darkTheme = prefs.getBool(key) ?? true;
    //   notifyListeners();
    // }

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                username,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                email,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(photoUrl),
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
          ],
        ),
      ),
    );
  }
}
