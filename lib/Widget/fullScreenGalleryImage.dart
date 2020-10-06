import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenGalleryImage extends StatelessWidget {
  String url;
  FullScreenGalleryImage({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained * 1,
          imageProvider: NetworkImage(url),
          backgroundDecoration: BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
}
