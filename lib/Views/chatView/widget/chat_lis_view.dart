import 'package:ChatApp/Views/chatView/widget/last_message.dart';
import 'package:ChatApp/Views/chatView/widget/online_indicator.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/Widget/fullscreenImage.dart';
import 'package:ChatApp/modal/contacts.dart';
import 'package:ChatApp/modal/message.dart';
import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListView extends StatelessWidget {
  final Contact contact;
  final DatabaseMethods _authenticationMethods = DatabaseMethods();

  ChatListView(this.contact);

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

class ViewLayout extends StatelessWidget {
  final Users contact;
  final DatabaseMethods _chatMethods = DatabaseMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    Message _message; 

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
                        url: contact.photoUrl != null
                            ? contact.photoUrl
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
                radius: 30,
                backgroundColor: Colors.black,
                child: Material(
                  child: contact.photoUrl != null
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
                            errorWidget: (context, url, dynamic error) => Material(
                    child: Image.asset(
                      'images/placeHolder.jpg',
                      width: 200.0,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                          imageUrl: contact.photoUrl,
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
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            )),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
             
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<MaterialPageRoute>(
                  builder: (context) => ConversationScreen(
                    recevier: contact,
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 15),
               
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          
                          
                          child: Text(
                            (contact != null ? contact.username : null) != null
                                ? contact.username
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
                        // Container(
                        //   width: 7,
                        //   height: 7,
                        //   child: OnlineIndicator(
                        //     uid: contact.userId,
                        //   ),
                        // ),
                        Container(
                          child: LastMessageTimeContainer(
                            stream: _chatMethods.fetchLastMessageBetween(
                              id: userProvider.getUser.userId,
                              receiverId: contact.userId,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: LastMessageContainer(
                        stream: _chatMethods.fetchLastMessageBetween(
                          id: userProvider.getUser.userId,
                          receiverId: contact.userId,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
