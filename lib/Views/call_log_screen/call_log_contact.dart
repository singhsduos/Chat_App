import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:ChatApp/modal/contacts.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/utils/call_utilities.dart';
import 'package:ChatApp/utils/permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  Widget appBarTitle = Text(
    'Select contact',
    style: TextStyle(
      fontSize: 19.0,
      fontFamily: 'Arial ',
      letterSpacing: 1.0,
      color: Colors.white,
    ),
  );
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("AppBar Title");
                  }
                });
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 27,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: ContactListContainer(),
      ),
    );
  }
}

class ContactListContainer extends StatelessWidget {
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: databaseMethods.fetchContacts(
            userId: userProvider.getUser.userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.docs;

              if (docList.isEmpty) {
                return SearchCallContactBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());

                  return ContactListView(contact);
                },
              );
            }

            return Center(child: Container());
          }),
    );
  }
}

class ContactListView extends StatelessWidget {
  final Contact contact;
  final DatabaseMethods _authenticationMethods = DatabaseMethods();

  ContactListView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: _authenticationMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Users user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: Container(),
        );
      },
    );
  }
}

class ViewLayout extends StatefulWidget {
  final Users contact;

  ViewLayout({
    @required this.contact,
  });

  @override
  _ViewLayoutState createState() => _ViewLayoutState();
}

class _ViewLayoutState extends State<ViewLayout> {
  Users sender;

  final DatabaseMethods _chatMethods = DatabaseMethods();

  String _currentUserId;
  String username = '';
  String email = '';
  String createdAt = '';
  String photoUrl = '';
  String aboutMe = '';
  String id = '';
  SharedPreferences preferences;

  Future readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    photoUrl = preferences.getString('photoUrl');
    username = preferences.getString('username');
    email = preferences.getString('email');
    aboutMe = preferences.getString('aboutMe');
    createdAt = preferences.getString('createdAt');
    id = preferences.getString('id');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readDataFromLocal();

    _chatMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender =
            Users(userId: user.uid, username: username, photoUrl: photoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              {
                Navigator.push<MaterialPageRoute>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FullScreenImagePage(
                        url: widget.contact.photoUrl != null
                            ? widget.contact.photoUrl
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
                radius: 24,
                backgroundColor: Colors.black,
                child: Material(
                  child: widget.contact.photoUrl != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('images/placeHolder.jpg'),
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
                          imageUrl: widget.contact.photoUrl,
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
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          (widget.contact != null
                                      ? widget.contact.username
                                      : null) !=
                                  null
                              ? widget.contact.username
                              : '..',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Arial",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              wordSpacing: 1.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async =>
                            await Permissions.microphonePermissionsGranted()
                                ? CallUtils.dialVoice(
                                    from: sender,
                                    to: widget.contact,
                                    context: context,
                                    callis: "audio")
                                : () {},
                        child: Container(
                            child: Icon(
                          Icons.call,
                          color: Colors.cyan,
                        )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () async => await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            ? CallUtils.dial(
                                from: sender,
                                to: widget.contact,
                                context: context,
                                callis: "video")
                            : () {},
                        child: Container(
                            child: Icon(
                          Icons.video_call,
                          color: Colors.cyan,
                        )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
