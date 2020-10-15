import 'package:ChatApp/Views/call_screen/pickup/pickup_layout.dart';
import 'package:ChatApp/Views/chatView/widget/chat_lis_view.dart';
import 'package:ChatApp/Views/search.dart';
import 'package:ChatApp/Widget/quietbox.dart';
import 'package:ChatApp/modal/contacts.dart';
import 'package:ChatApp/provider/provider.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.transparent,
        body: ChatListContainer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: () {
            Navigator.push<MaterialPageRoute>(context,
                MaterialPageRoute(builder: (BuildContext context) => Search()));
          },
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
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
                return ContactQuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());

                  return ChatListView(contact);
                },
              );
            }

            return Center(child: Container());
          }),
    );
  }
}


