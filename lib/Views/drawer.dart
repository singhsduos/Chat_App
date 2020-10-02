import 'package:ChatApp/Views/account_setting.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  bool isDarkTheme = false;
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
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: Consumer<ThemeNotifier>(
                builder: (BuildContext context, ThemeNotifier notifier,
                        Widget child) =>
                    SwitchListTile(
                      
                  title: const Text(
                    'Dark theme',
                    style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        )
                  ),
                   subtitle: Text('Reduce glare and improve night viewing',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
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
                  Navigator.push<MaterialPageRoute>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Settings()));
                },
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.edit),
                    title: Text('Accounts Settings',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        )),
                    subtitle: Text('Personal',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.0,
                        )),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
            ),
            //     ListTile(
            //   leading: Icon(Icons.person),
            //   trailing: Icon(Icons.edit),
            //   title: Text('Accounts Settings',
            //       style: TextStyle(
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.bold,
            //         letterSpacing: 1.0,

            //       )),
            //   subtitle: Text('Personal',
            //       style: TextStyle(
            //         fontSize: 17.0,
            //         fontWeight: FontWeight.normal,
            //         letterSpacing: 1.0,

            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
