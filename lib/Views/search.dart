import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/database.dart';

import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  State createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String currentUserId;
  String username;
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<Users> userList;
  String query = '';

  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseMethods.getCurrentUser().then((User user) {
      databaseMethods.fetchAllUsers(user).then((List<Users> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  dynamic emptyTextFormField() {
    searchTextEditingController.clear();
  }

  Widget buildSuggestions(String query) {
    final List<Users> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((Users users) {
                String _getUsername = users.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getEmail = users.email.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesEmail = _getEmail.contains(_query);
                return (matchesEmail || matchesUsername);
              }).toList()
            : [];

    if (suggestionList.isEmpty) {
      return SearchUserContainer();
    }

    return ListView.builder(
      // shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        Users searchedUser = Users(
          userId: suggestionList[index].userId,
          photoUrl: suggestionList[index].photoUrl,
          aboutMe: suggestionList[index].aboutMe,
          email: suggestionList[index].email,
          createdAt: suggestionList[index].createdAt,
          username: suggestionList[index].username,
        );
        // print("Role: " + searchedUser.role);
        return ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute<MaterialPageRoute>(
                    builder: (context) => ConversationScreen(
                          recevier: searchedUser,
                        )));
          },
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Material(
              child: searchedUser.photoUrl.toString() != null
                  ? CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/placeHolder.jpg'),
                        )),
                        height: 80,
                        width: 80,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      ),
                      imageUrl: '${searchedUser.photoUrl}',
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 60.0,
                      color: Colors.white,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(125.0)),
              clipBehavior: Clip.hardEdge,
            ),
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.email,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontStyle: FontStyle.italic),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget searchAppBar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [Colors.cyan, Colors.cyan],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 27,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'ChaTooApp',
        style: TextStyle(
          fontSize: 17.0,
          fontFamily: 'UncialAntiqua',
          letterSpacing: 1.0,
          color: Colors.white,
        ),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchTextEditingController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.black,
            autofocus: false,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person_pin,
                size: 30.0,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => searchTextEditingController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search Username...",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xfffecf0f1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
          scaffold: Scaffold(
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.all(4.0),
          child: buildSuggestions(query),
        ),
      ),
    );
  }
}

class SearchUserContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.cyan,
                ),
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 250,
                    ),
                    SizedBox(height: 25),
                     Text(
                      'Search users with their username or email.',
                      style: TextStyle(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.white),
                          textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
