import 'package:flutter/material.dart';
import 'package:ChatApp/modal/user.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget icon;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  CustomTile(
      {@required this.leading,
      @required this.title,
      @required this.subtitle,
      this.icon,
      this.trailing,
      this.margin = const EdgeInsets.all(0),
      this.mini = true,
      this.onTap,
      this.onLongPress});

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(vertical: mini ? 4 : 16),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Colors.white))),
        child: Row(
          children: <Widget>[
            leading,
            Container(
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      title ?? Container(),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          icon ?? Container(),
                          subtitle,
                        ],
                      )
                    ],
                  ),
                  trailing ?? Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
