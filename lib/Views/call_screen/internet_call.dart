import 'dart:async';
import 'package:ChatApp/configs/agora_configs.dart';
import 'package:ChatApp/modal/call.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/call_methods.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class VoiceCallScreen extends StatefulWidget {
  final ClientRole role;
  final Call call;

  VoiceCallScreen({@required this.call, @required this.role});

  @override
  _VoiceCallScreenState createState() =>
      _VoiceCallScreenState(role: role, call: call);
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  UserProvider userProvider;
  final CallMethods callMethods = CallMethods();
  StreamSubscription callStreamSubscription;
  final ClientRole role;
  final Call call;

  _VoiceCallScreenState({@required this.call, @required this.role});

  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    // initialize agora sdk
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // ignore: deprecated_member_use
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(null, widget.call.channelId, null, 0);
  }

  void addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      callStreamSubscription = callMethods
          .callStream(userId: userProvider.getUser.userId)
          .listen((DocumentSnapshot ds) {
        if (ds.data() == null) {
          Navigator.pop(context);
        } else {
          return;
        }
      });
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      // if (!mounted) return;
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
        _engine.disableVideo();
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      // if (!mounted) return;
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
        _engine.disableVideo();
      });
    }, leaveChannel: (stats) {
      if (!mounted) return;

      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
        _engine.disableVideo();
      });
    }, userJoined: (uid, elapsed) {
      // if (!mounted) return;
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        _engine.disableVideo();
      });
    }, userOffline: (uid, elapsed) {
      callMethods.endCall(call: widget.call);
      if (!mounted) return;
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
        _engine.disableVideo();
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      // if (!mounted) return;
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
        _engine.disableVideo();
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(Widget view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    if (call.hasDialled == true) {
      return Scaffold(
        backgroundColor: Colors.cyan,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.cyan,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  call.receiverName,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                (call.isCall == 'audio' || call.isCall == 'video')
                    ? Text(
                        'Connected',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Connected',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                SizedBox(
                  height: 50,
                ),
                Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/placeHolder.jpg'),
                      )),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    errorWidget: (context, url, dynamic error) => Material(
                      child: Image.asset(
                        'images/placeHolder.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(125.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: call.receiverPic,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    fit: BoxFit.cover,
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: _onToggleMute,
                      child: Icon(
                        muted ? Icons.mic_off : Icons.mic,
                        color: muted ? Colors.white : Colors.blueAccent,
                        size: 20.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: muted ? Colors.blueAccent : Colors.white,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    RawMaterialButton(
                      onPressed: () => callMethods.endCall(call: widget.call),
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.redAccent,
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.cyan,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            color: Colors.cyan,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  call.callerName,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Connected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/placeHolder.jpg'),
                      )),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    errorWidget: (context, url, dynamic error) => Material(
                      child: Image.asset(
                        'images/placeHolder.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(125.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: call.callerPic,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    fit: BoxFit.cover,
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: _onToggleMute,
                      child: Icon(
                        muted ? Icons.mic_off : Icons.mic,
                        color: muted ? Colors.white : Colors.blueAccent,
                        size: 20.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: muted ? Colors.blueAccent : Colors.white,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    RawMaterialButton(
                      onPressed: () => callMethods.endCall(call: widget.call),
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.redAccent,
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
