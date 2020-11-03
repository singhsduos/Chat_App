import 'package:flutter/material.dart';

class CustomDialog {
  static Future showScaleAlertBox({
    @required BuildContext context,
    @required String title,
    IconData icon,
    @required String text,
    @required String firstButton,
  }) {
    return showGeneralDialog<Widget>(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                title: Center(
                    child: Text(
                  title,
                  style: TextStyle(color: Colors.cyan),
                )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.cyan,
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        text,
                        style: TextStyle(color:Colors.cyan),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                    // OPTIONAL BUTTON
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    color: Colors.cyan,
                    child: Text(
                      firstButton,
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 128),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return null;
        });
  }
}