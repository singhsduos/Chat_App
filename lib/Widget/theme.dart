import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MyThemeKeys { LIGHT, DARK }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
      primaryColor: Colors.cyan,
      brightness: Brightness.light,
      splashColor: Colors.cyan);

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.cyan,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Colors.black,
    cardColor: Colors.black,
    canvasColor: Colors.black, // specially for background drawer color
    dialogBackgroundColor: Colors.black87,
    primaryColorDark: Colors.black,
    splashColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black87),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences preferences;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }
  dynamic toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  dynamic _initPrefs() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  dynamic _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = preferences.getBool(key) ?? false;
    notifyListeners();
  }

  dynamic _saveToPrefs() async {
    await _initPrefs();
    preferences.setBool(key, _darkTheme);
  }
}
