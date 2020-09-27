import 'dart:async';

import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/helper/constants.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  final CollectionReference useref = Firestore.instance.collection("users");

  dynamic handleSearch(String query) {
    Future<QuerySnapshot> users =
        useref.where("username", isGreaterThanOrEqualTo: query).getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  dynamic clearSearch() {
    searchController.clear();
  }

  // AppBar buildSearchField() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     title: TextFormField(
  //       controller: searchController,
  //       decoration: InputDecoration(
  //         hintText: "Search for a user...",
  //         filled: true,
  //         prefixIcon: Icon(
  //           Icons.account_box,
  //           size: 28.0,
  //         ),
  //         suffixIcon: IconButton(
  //           icon: Icon(Icons.clear),
  //           onPressed: clearSearch,
  //         ),
  //       ),
  //       onFieldSubmitted: handleSearch,
  //     ),
  //   );
  // }
//   Widget userList() {
//     return haveUserSearched
//         ? ListView.builder(
//             shrinkWrap: true,
//             itemCount: searchResultSnapshot.docs.length,
//             itemBuilder: (context, index) {
//               return userTile(
//                 username:
//                     ('${searchResultSnapshot.docs[0].data()['username']}'),
//                 email:
//                     ('${searchResultSnapshot.docs[0].data()['username']}'),
//               );
//             })
//         : Container();
//   }
    Widget userList() {
    return FutureBuilder(
      
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Text> searchResults = [];
        snapshot.data.documents.forEach((DocumentSnapshot doc) {
          Users user = Users.fromDocument(doc);
          searchResults.add(Text(user.username));
        });
        return ListView(
          children: searchResults,
        );
      },
    );
        
  }
  

 

  Widget buildSearchResults(BuildContext context) {
    return Scaffold(
      body: 
          searchResultsFuture != null ? Container( child: Center(
                child: CircularProgressIndicator(),
              ),) : Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.cyan,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // handleSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          "images/search_white.png",
                          height: 25,
                          width: 25,
                        )),
                  )
                ],
              ),
            ),
            userList(),
          ],
        ),
      ),
    );
  }

  // Widget buildSearchResults() {
  //   return FutureBuilder(
  //     future: searchResultsFuture,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return CircularProgressIndicator();
  //       }
  //       List<Text> searchResults = [];
  //       snapshot.data.documents.forEach((DocumentSnapshot doc) {
  //         Users user = Users.fromDocument(doc);
  //         searchResults.add(Text(user.username));
  //       });
  //       return ListView(
  //         children: searchResults,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: appBarMain(context),
      body: buildSearchResults(context),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}

// class _SearchState extends State<Search> {
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   TextEditingController searchEditingController = new TextEditingController();
//   Future<QuerySnapshot> searchResultSnapshot;
//   QuerySnapshot user;
//   String query = '';
//   bool isLoading = false;
//   bool haveUserSearched = false;

//   dynamic initiateSearch() async {
//     if (searchEditingController.text.isNotEmpty) {
//       setState(() {
//         isLoading = true;
//       });
//       await databaseMethods
//           .getByUserName(searchEditingController.text)
//           .then((user) {
//         searchResultSnapshot = user as Future<QuerySnapshot>;
//         print("$searchResultSnapshot");
//         //  searchResultSnapshot =  snapshot;
//         setState(() {
//           isLoading = false;
//           haveUserSearched = true;
//         });
//       });
//     }
//   }

//   Widget userList() {
//     return haveUserSearched
//         ? ListView.builder(
//             shrinkWrap: true,
//             itemCount: searchResultSnapshot.docs.length,
//             itemBuilder: (context, index) {
//               return userTile(
//                 username:
//                     ('${searchResultSnapshot.docs[0].data()['username']}'),
//                 email:
//                     ('${searchResultSnapshot.docs[0].data()['username']}'),
//               );
//             })
//         : Container();
//   }

//   // 1.create a chatroom, send user to the chatroom, other userdetails
//   dynamic sendMessage(String username) {
//     List<String> users = [username, Constants.myName];

//     String chatRoomid = getChatRoomid(username, Constants.myName).toString();

//     Map<String, dynamic> chatRoomMap = <String, dynamic>{
//       "users": users,
//       "chatRoomid": chatRoomid,
//     };

//     databaseMethods.createChatRoom(chatRoomMap, chatRoomid);

//     Navigator.push(
//         context,
//         MaterialPageRoute<MaterialPageRoute>(
//             builder: (BuildContext context) => ConversationScreen(chatRoomid)));
//   }

//   Widget userTile({String username, String email}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 username,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//               Text(
//                 email,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               )
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               sendMessage(username);
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                   color: Colors.cyan, borderRadius: BorderRadius.circular(24)),
//               child: Text(
//                 "Message",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarMain(context),
//       body: isLoading
//           ? Container(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Container(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                     color: Colors.cyan,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: searchEditingController,
//                             style: TextStyle(
//                               fontSize: 16,
//                               letterSpacing: 1.0,
//                             ),
//                             decoration: InputDecoration(
//                                 hintText: "search username ...",
//                                 hintStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                 ),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             initiateSearch();
//                           },
//                           child: Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                       colors: [
//                                         const Color(0x36FFFFFF),
//                                         const Color(0x0FFFFFFF)
//                                       ],
//                                       begin: FractionalOffset.topLeft,
//                                       end: FractionalOffset.bottomRight),
//                                   borderRadius: BorderRadius.circular(40)),
//                               padding: EdgeInsets.all(12),
//                               child: Image.asset(
//                                 "images/search_white.png",
//                                 height: 25,
//                                 width: 25,
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                   userList(),
//                 ],
//               ),
//             ),
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
//         ? ListView.builder(
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

//   dynamic createChatroomAndStartConversation({String username}) {
//     // print('${Constants.myName}');
//     if (username != Constants.myName) {
//       final String chatRoomid =
//           getChatRoomid(username, Constants.myName).toString();

//       final List<String> users = [username, Constants.myName];
//       final Map<String, dynamic> chatRoomMap = {
//         'users': users,
//         'chatroomid': chatRoomid,
//       }.cast<String, dynamic>();
//       databaseMethods.createChatRoom(chatRoomMap, chatRoomid);
//       Navigator.push(
//           context,
//           MaterialPageRoute<MaterialPageRoute>(
//               builder: (BuildContext context) =>
//                   ConversationScreen(chatRoomid)));
//     } else {
//       print('you cannot send message to yourself');
//     }
//   }

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
