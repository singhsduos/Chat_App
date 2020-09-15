import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'ChaTooApp',
      style: TextStyle(
        fontSize: 17.0,
        fontFamily: 'UncialAntiqua',
        letterSpacing: 1.0,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.cyan,
    iconTheme: IconThemeData(color: Colors.white)
  );
}