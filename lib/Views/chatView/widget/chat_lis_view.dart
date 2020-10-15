import 'package:ChatApp/Views/chatView/widget/last_message.dart';
import 'package:ChatApp/Views/conversationScreen.dart';
import 'package:ChatApp/modal/contacts.dart';
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
          child: CircularProgressIndicator(),
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

    return ListTile(
      // mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute<MaterialPageRoute>(
            builder: (context) => ConversationScreen(
              recevier: contact,
            ),
          )),
      title: Padding(
        padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        child: Text(
          (contact != null ? contact.username : null) != null
              ? contact.username
              : '..',
          style:
              TextStyle(color: Colors.grey, fontFamily: "Arial", fontSize: 19),
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        child: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.userId,
            receiverId: contact.userId,
          ),
        ),
      ),
      leading: Container(
        // constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            Material(
              child: contact.photoUrl != null
                  ? CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(15.0),
                      ),
                      imageUrl: contact.photoUrl,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 50.0,
                      color: Colors.cyan,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            // OnlineDotIndicator(
            //   uid: contact.userId,
            // ),
          ],
        ),
      ),
    );
  }
}
