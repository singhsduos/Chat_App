import 'dart:io';
import 'dart:math';
import 'package:ChatApp/enum/users_state.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  // this is new

 
  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.OFFLINE:
        return 0;

      case UserState.ONLINE:
        return 1;

      case UserState.WAITING:
        return 2;

      default:
        return 3;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.OFFLINE;

      case 1:
        return UserState.ONLINE;

      case 2:
        return UserState.WAITING;

      default:
        return UserState.OFFLINE;
    }
  }

}
