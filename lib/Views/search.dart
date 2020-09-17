import 'package:ChatApp/Widget/widget.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot searchSnapshot;

  dynamic initiateSearch() {
    databaseMethods
        .getByUserName(searchTextEditingController.text)
        .then((val) => setState(() {
              searchSnapshot = val as QuerySnapshot;
            }));
  }

//  dynamic createChatroomAndStartConversation(String userName){
//     List<String> users = [userName, ];
//     databaseMethods.createChatRoom();
//   }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: ('${searchSnapshot.documents[index].data()['name']}'),
                userEmail:
                    ('${searchSnapshot.documents[index].data()['email']}'),
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        initiateSearch();
                        databaseMethods
                            .getByUserName(searchTextEditingController.text)
                            .then((String value) => print(value.toString()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                              fontSize: 16),
                          cursorColor: Colors.black54,
                          decoration: InputDecoration(
                            suffixIcon: Container(
                              child: Icon(
                                Icons.search,
                                color: Colors.black54,
                              ),
                            ),
                            fillColor: Color(0xfff99AAAB),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 2),
                            ),
                            hintText: 'search Username...',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                            ),
                            filled: true,
                            labelStyle: new TextStyle(
                                color: Color(0xfff99AAAB), fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
              ),
              Text(userEmail)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  "Message",
                )),
          )
        ],
      ),
    );
  }
}
