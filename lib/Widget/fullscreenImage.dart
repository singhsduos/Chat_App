import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullScreenImagePage extends StatefulWidget {
  final String url;
  FullScreenImagePage({Key key, @required this.url}) : super(key: key);

  @override
  _FullScreenImagePageState createState() =>
      _FullScreenImagePageState(url: url);
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  final String url;
  bool downloading = false;
  String progressString = '';

  _FullScreenImagePageState({
    Key key,
    @required this.url,
  });

  @override
  void initState() {
    super.initState();
    // onImagDownloadButtonPressed();'
  }

  Future onImagDownloadButtonPressed() async {
    Dio dio = Dio();
    try {
      final dir = await getExternalStorageDirectory();
      final String savePath = dir.path + "/ChatooApp_${DateTime.now().millisecondsSinceEpoch}.jpg";
      await dio.download(url, savePath, onReceiveProgress: (receive, total) {
        print("Receive: $receive, Total: $total");

        setState(() {
          downloading = true;
          progressString = ((receive / total) * 100).toStringAsFixed(0) + '%';
        });
      });

      GallerySaver.saveImage(savePath).then((bool success) {
        setState(() {
          print('Image is saved');
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = 'Download completed';
      Fluttertoast.showToast(
        msg: progressString,
        textColor: Color(0xFFFFFFFF),
        fontSize: 16.0,
        // timeInSecForIosWeb: 4,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.cyan,
      );
    });
    print('Download completed');
  }

  
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.vertical_align_bottom,
                color: Colors.white,
                size: 23,
              ),
              onPressed: onImagDownloadButtonPressed,
            ),
          ],
          title: Text(
            'Profile photo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: downloading
              ? Container(
                  height: 200.0,
                  width: 270.0,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: 50,
                        ),
                        Text('Downloading profile picture : $progressString',
                            style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
              : FullImage(
                  url: widget.url,
                ),
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
    return Container(
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
