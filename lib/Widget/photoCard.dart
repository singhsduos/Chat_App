import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Widget/customTile.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:ChatApp/modal/contacts.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/utils/call_utilities.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDialog extends StatelessWidget {
  final String url;
  final Widget title;
  final Widget icon;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final Widget icon1;
  final Widget icon2;
  final Widget icon3;
  final Widget icon4;
  CustomDialog({
    @required this.url,
    @required this.title,
    this.icon,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.mini = true,
    this.onTap,
    this.onLongPress,
    this.icon1,
    this.icon2,
    this.icon3,
    this.icon4,
  });

  Widget dialogContent(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 310,
            width: 260,
            padding: EdgeInsets.only(
              top: Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            // margin: EdgeInsets.only(top: Consts.avatarRadius),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 12,
                      ),
                      title,
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    {
                      Navigator.push<MaterialPageRoute>(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FullScreenImagePage(
                            url: url != null
                                ? url
                                : 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    child: Material(
                      child: url != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage('images/placeHolder.jpg'),
                                )),
                                height: 200,
                                width: 200,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              ),
                              errorWidget: (context, url, dynamic error) =>
                                  Material(
                                child: Image.asset(
                                  'images/placeHolder.jpg',
                                  width: 200.0,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                // borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: url,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: Colors.cyan,
                            ),
                      clipBehavior: Clip.hardEdge,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        icon1,
                        icon2,
                        icon3,
                        icon4,
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
          scaffold: Dialog(
        child: dialogContent(context),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
