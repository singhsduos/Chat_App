import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  bool isDarkTheme = false;
  @override
  Widget build(BuildContext context) {
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

    return SafeArea(
      child : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SwitchListTile(
              title: Text(
                'Switch DarkMode',
                style: TextStyle(
                  fontSize: 17.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: isDarkTheme,
              activeTrackColor: Colors.blueGrey,
              activeColor: Colors.cyan,
              onChanged: (value) {
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
          ],
        ),
      ),
    );
  }
}
