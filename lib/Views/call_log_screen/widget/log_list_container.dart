import 'package:ChatApp/Widget/customTile.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:ChatApp/helper/strings.dart';
import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/services/repository_log/log_repository.dart';
import 'package:ChatApp/utils/utilites.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  Widget getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.cyan,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.greenAccent,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data as List<dynamic>;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i] as Log;
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

                return CustomTile(
                  leading: GestureDetector(
                    onTap: () {
                      {
                        Navigator.push<MaterialPageRoute>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => FullScreenImagePage(
                                url: _log.receiverPic != null
                                    ? _log.receiverPic
                                    : 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan, width: 2),
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Material(
                          child: (hasDialled
                                      ? _log.receiverPic
                                      : _log.callerPic) !=
                                  null
                              ? CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image:
                                          AssetImage('images/placeHolder.jpg'),
                                    )),
                                    height: 80,
                                    width: 80,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: (hasDialled
                                      ? _log.receiverPic
                                      : _log.callerPic),
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 60.0,
                                  color: Colors.white,
                                ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(125.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ),
                    ),
                  ),
                  mini: false,
                  onLongPress: () => showDialog<Null>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Center(
                        child: Text(
                          "Delete this Log?",
                        ),
                      ),
                      content: Text(
                        "Are you sure you wish to delete this log?",
                        style: TextStyle(color: Colors.cyan),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "NO",
                            style: TextStyle(color: Colors.cyan),
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        FlatButton(
                          child: Text(
                            "YES",
                            style: TextStyle(color: Colors.cyan),
                          ),
                          onPressed: () async {
                            Navigator.maybePop(context);
                            await LogRepository.deleteLogs(i);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    hasDialled
                        ? _log?.receiverName ?? ".."
                        : _log?.callerName ?? "..s",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  icon: getIcon(_log.callStatus),
                  subtitle: Text(
                    DateFormat("dd MMM yyyy - hh:mm aa").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(_log.timestamp))),
                    style: TextStyle(
                      fontSize: 13,
                      // color: Colors.white,
                    ),
                  ),
                );
              },
            );
          }
          return QuietBox(
            heading: 'This is where all your call logs are listed.',
          );
        }
        return QuietBox(
          heading: 'This is where all your call logs are listed.',
        );
      },
    );
  }
}
