import 'package:ChatApp/Views/drawer.dart';
import 'package:ChatApp/Views/search.dart';
import 'package:ChatApp/Views/signIn.dart';
import 'package:ChatApp/Widget/customtheme.dart';
import 'package:ChatApp/Widget/theme.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/authenticate.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'ChaTooApp',
//           style: TextStyle(
//             fontSize: 17.0,
//             fontFamily: 'UncialAntiqua',
//             letterSpacing: 1.0,
//             color: Colors.white,
//           ),
//         ),

//         actions: <Widget>[
//           GestureDetector(
//             onTap: () {
//               authMethods.signOut();
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute<MaterialPageRoute>(
//                       builder: (BuildContext context) => Authenticate()));
//             },
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(
//                   Icons.exit_to_app,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//         backgroundColor: Colors.cyan,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push<MaterialPageRoute>(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => SearchScreen()));
//         },
//         child: Icon(
//           Icons.search,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
      CustomTheme.instanceOf(buildContext).changeTheme(key);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          'ChaTooApp',
          style: TextStyle(
            fontSize: 17.0,
            fontFamily: 'UncialAntiqua',
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<MaterialPageRoute>(
                      builder: (BuildContext context) => Authenticate()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.cyan,
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen()));
        },
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Center(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisSize: MainAxisSize.max,
      //       children: <Widget>[
      //         AnimatedContainer(
      //           duration: Duration(milliseconds: 500),
      //           color: Theme.of(context).primaryColor,
      //           width: 100,
      //           height: 100,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
