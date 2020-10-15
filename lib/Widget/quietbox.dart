import 'package:flutter/material.dart';

class ContactQuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
              Text(
                "This is where all yours contact messages are displayed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
              SizedBox(height: 25),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "To start chatting with family and friends, tap ",
                      style: TextStyle(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    WidgetSpan(
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: " at the bottom of your screen.",
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
