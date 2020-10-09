import 'package:ChatApp/modal/user.dart';
import 'package:ChatApp/services/database.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  Users _user;
  DatabaseMethods databaseMethods = DatabaseMethods();

  Users get getUser => _user;

  void refreshUser() async {
    Users user = await databaseMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
