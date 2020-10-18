import 'package:ChatApp/Widget/customTile.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:ChatApp/helper/strings.dart';
import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/services/repository/log_repository.dart';
import 'package:ChatApp/utils/utilites.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
          color: Colors.greenAccent,
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
          color: Colors.redAccent,
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
    return FutureBuilder<Log>(
      // future: LogRepository.getLogs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // if (snapshot.hasData) {
        //   List<Log> logList = snapshot.data;

        //   if (logList.isNotEmpty) {
        //     return ListView.builder(
        //       itemCount: logList.length,
        //       itemBuilder: (context, i) {
        //         Log _log = logList[i];
        //         bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

        //         return CustomTile(
        //           leading: CachedNetworkImage(
        //            imageUrl:  hasDialled ? _log.receiverPic : _log.callerPic,
        //           ),
        //           onLongPress: () => showDialog<Null>(
        //             context: context,
        //             builder: (context) => AlertDialog(
        //               title: Text(
        //                 "Delete this Log?",
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //               content: Text(
        //                 "Are you sure you wish to delete this log?",
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //               actions: [
        //                 FlatButton(
        //                   child: Text("YES"),
        //                   onPressed: () async {
        //                     Navigator.maybePop(context);
        //                     await LogRepository.deleteLogs(i);
        //                     if (mounted) {
        //                       setState(() {});
        //                     }
        //                   },
        //                 ),
        //                 FlatButton(
        //                   child: Text("NO"),
        //                   onPressed: () => Navigator.maybePop(context),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           title: Text(
        //             hasDialled
        //                 ? _log?.receiverName ?? ".."
        //                 : _log?.callerName ?? "..s",
        //             style: TextStyle(
        //               fontWeight: FontWeight.w600,
        //               fontSize: 17,
        //             ),
        //           ),
        //           icon: getIcon(_log.callStatus),
        //           subtitle: Text(
        //             Utils.formatDateString(_log.timestamp),
        //             style: TextStyle(
        //               fontSize: 13,
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   }
        // }
        return QuietBox(
          heading: 'This is where all your call logs are listed.',
        );
      },
    );
  }
}
