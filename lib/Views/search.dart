import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final String currentUserId;
  Search({Key key, @required this.currentUserId}) : super(key: key);
  @override
  State createState() => _SearchState(currentUserId: currentUserId);
}

String _myName;

class _SearchState extends State<Search> {
  String currentUserId;
  String username;
  DatabaseMethods databaseMethods = DatabaseMethods();

  _SearchState({Key key, @required this.currentUserId});
  TextEditingController searchTextEditingController = TextEditingController();

  AppBar homepageHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.cyan,
     leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 27,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      title: Container(
        margin: EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          style: TextStyle(fontSize: 18.0, color: Colors.white),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: 'search Username...',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            prefixIcon: Icon(
              Icons.person_pin,
              size: 28.0,
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              color: Colors.white,
              onPressed: emptyTextFormField,
            ),
          ),
          onFieldSubmitted: handleSearch,
        ),
      ),
    );
  }

  Future<QuerySnapshot> searchResultsFuture;
  final CollectionReference useref =
      FirebaseFirestore.instance.collection("users");

  dynamic handleSearch(String query) async {
    Future<QuerySnapshot> users = FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  dynamic emptyTextFormField() {
    searchTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homepageHeader(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }

  Widget buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<UserResult> searchResults = [];
        datasnapshot.data.documents.forEach((DocumentSnapshot doc) {
          final Map getDocs = doc.data();
          Users user = Users.fromDocument(doc);

          UserResult userResult = UserResult(user);

          if (currentUserId != getDocs['id']) {
            searchResults.add(userResult);
          }
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.group,
              color: Colors.cyan,
              size: 200.0,
            ),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.cyan,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                fontSize: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  Users users;
  UserResult(this.users);
  DatabaseMethods databaseMethods = DatabaseMethods();

  dynamic createChatroomAndStartConversation(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<MaterialPageRoute>(
            builder: (BuildContext context) => ConversationScreen(
                  chatRoomid: users.userId,
                  recevierAvatar: users.photoUrl,
                  recevierName: users.username,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                createChatroomAndStartConversation(context);
              },
              child: ListTile(
                leading: CircleAvatar(
                  // backgroundColor: Colors.black,
                  
                  backgroundImage: CachedNetworkImageProvider(users.photoUrl),
                ),
                title: Text(
                  users.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Joined: ' +
                      DateFormat('dd MMMM, yyyy - hh:mm:aa')
                          .format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(users.createdAt)),
                          )
                          .toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//2nd method

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// String _myName;

// class _SearchScreenState extends State<SearchScreen> {
//   DatabaseMethods databaseMethods = DatabaseMethods();
//   TextEditingController searchTextEditingController = TextEditingController();

//   QuerySnapshot searchSnapshot;
//   bool isLoading = false;
//   bool haveUserSearched = false;
//   String username;
//   StreamSubscription<DocumentSnapshot> subscription;
//   final CollectionReference users =
//       FirebaseFirestore.instance.collection('users');

//   List usernameList = List<dynamic>();

//   dynamic initiateSearch() async {
//     dynamic resultant =
//         // await DatabaseMethods().getByUserName(usernameList.toString());
//         await DatabaseMethods().getByUserName();
//     if (resultant == null) {
//       print('unable to retrieve');
//     } else {
//       setState(() {
//         usernameList = resultant as List;
//       });
//     }
//   }

//   // dynamic initiateSearch() async {
//   //   if (searchTextEditingController.text.isNotEmpty) {
//   //     setState(() {
//   //       isLoading = true;
//   //     });
//   //     await databaseMethods
//   //         .getByUserName()
//   //         .then((snapshot) {
//   //       searchSnapshot = snapshot as QuerySnapshot;
//   //       // print('$searchSnapshot');
//   //       setState(() {
//   //         // searchSnapshot = snapshot as QuerySnapshot;
//   //         isLoading = false;
//   //         haveUserSearched = true;
//   //       });
//   //     });
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // initiateSearch();
//   }

//   Widget searchList() {
//     return haveUserSearched
//          ListView.builder(
//             shrinkWrap: true,
//             itemCount: searchSnapshot.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               return SearchTile(
//                 '${searchSnapshot.docs[index].data()['username']}',
//                 '${searchSnapshot.docs[index].data()['email']}',
//                 // ('${searchSnapshot.documents[0].data()['username']}'),
//                 // ('${searchSnapshot.documents[0].data()['email']}'),
//               );
//             })
//         : Container();
//   }

// dynamic createChatroomAndStartConversation({String username}) {
//   // print('${Constants.myName}');
//   if (username != Constants.myName) {
//     final String chatRoomid =
//         getChatRoomid(username, Constants.myName).toString();

//     final List<String> users = [username, Constants.myName];
//     final Map<String, dynamic> chatRoomMap = {
//       'users': users,
//       'chatroomid': chatRoomid,
//     }.cast<String, dynamic>();
//     databaseMethods.createChatRoom(chatRoomMap, chatRoomid);
//     Navigator.push(
//         context,
//         MaterialPageRoute<MaterialPageRoute>(
//             builder: (BuildContext context) =>
//                 ConversationScreen(chatRoomid)));
//   } else {
//     print('you cannot send message to yourself');
//   }
// }

//   Widget SearchTile(String username, String email) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 username,
//                 style: TextStyle(
//                   fontSize: 17.0,
//                   letterSpacing: 1.0,
//                 ),
//               ),
//               Text(
//                 email,
//                 style: TextStyle(
//                   fontSize: 17.0,
//                   letterSpacing: 1.0,
//                 ),
//               )
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               createChatroomAndStartConversation(username: username);
//             },
//             child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.cyan,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Text(
//                   "Message",
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     letterSpacing: 1.0,
//                     color: const Color(0xFF53E0BC),
//                   ),
//                 )),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarMain(context),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.symmetric(),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         initiateSearch();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: TextField(
//                           controller: searchTextEditingController,
//                           style: TextStyle(
//                               color: Colors.white,
//                               letterSpacing: 1.0,
//                               fontSize: 16),
//                           cursorColor: Colors.black54,
//                           decoration: InputDecoration(
//                             prefixIcon: Container(
//                               child: Icon(
//                                 Icons.person_pin,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 Icons.search,
//                                 color: Colors.black54,
//                               ),
//                               onPressed: () {
//                                 // initState();
//                               },
//                             ),
//                             fillColor: Color(0xfff99AAAB),
//                             border: const OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20.0)),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20.0)),
//                               borderSide:
//                                   BorderSide(color: Colors.black54, width: 2),
//                             ),
//                             hintText: 'search Username...',
//                             hintStyle: TextStyle(
//                               color: Colors.black54,
//                             ),
//                             filled: true,
//                             labelStyle: const TextStyle(
//                                 color: Color(0xfff99AAAB), fontSize: 16.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             searchList(),
//           ],
//         ),
//       ),
//     );
//   }

//   dynamic getChatRoomid(String a, String b) {
//     if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
//       return "$b\_$a";
//     } else {
//       return "$a\_$b";
//     }
//   }
// }
