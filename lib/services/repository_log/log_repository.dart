import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/services/repository_log/local_db.dart/hive.methods.dart';
import 'package:ChatApp/services/repository_log/local_db.dart/sqlite_methods.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

class LogRepository {
  static dynamic dbObject;
  static bool isHive;
 

  static Future<void> init({@required bool isHive, @required String dbName}) async {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static void addLogs(Log log) => dbObject.addLogs(log);

  static void deleteLogs(int logId) =>
      dbObject.deleteLogs(logId);

  static Future<List<Log>> getLogs() => dbObject.getLogs() as Future<List<Log>>;

  static void close() => dbObject.close();
}
