import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/services/repository/local_db.dart/hive.methods.dart';
import 'package:ChatApp/services/repository/local_db.dart/sqlite_methods.dart';
import 'package:meta/meta.dart';


class LogRepository {
  static  dynamic  dbObject;
  static bool isHive;

  static dynamic init({@required bool isHive, @required String dbName}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static dynamic addLogs(Log log) => dbObject.addLogs(log);

  static dynamic deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static  dynamic getLogs() => dbObject.getLogs();

  static dynamic close() => dbObject.close();
}