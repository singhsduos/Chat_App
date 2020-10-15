import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/modal/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenGalleryImage extends StatelessWidget {
  String url;
  String iD;
  User user;

  FullScreenGalleryImage(
      {Key key, @required this.url, this.iD})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
          scaffold: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 23,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.black,
          title: Text(
           iD,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: FullImage(
          url: url,
        ),
      ),
    );
  }
}

class FullImage extends StatefulWidget {
  final String url;
  FullImage({Key key, @required this.url}) : super(key: key);

  @override
  _FullImageState createState() => _FullImageState(url: url);
}

class _FullImageState extends State<FullImage> {
  final String url;

  _FullImageState({
    Key key,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
        color: Colors.black,
        child: PhotoViewGallery(
          pageOptions: <PhotoViewGalleryPageOptions>[
            PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(url.toString()),
              minScale: PhotoViewComputedScale.contained * 1,
              // maxScale: PhotoViewComputedScale.covered * 1.1,
            ),
          ],
          loadingBuilder: (context, progress) => Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.black),
        ),
      );
  }
}
