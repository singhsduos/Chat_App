import 'dart:io';
import 'package:ChatApp/modal/log.dart';
import 'package:ChatApp/services/repository_log/local_db.dart/log_interferace.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  Database _db;

  String databaseName = "";
  String tableName = "Call_Logs";

  // columns
  String id = 'log_id';
  String callerName = "caller_name";
  String callerPic = "caller_pic";
  String receiverName = "receiver_name";
  String receiverPic = "receiver_pic";
  String callStatus = "call_status";
  String timestamp = "timestamp";
  String callerAboutMe = 'caller_aboutMe';
  String callerEmail = 'caller_email';
  // String callerCreatedAt = 'caller_createdAt';
  String receiverAboutMe = 'receiver_aboutMe';
  String receiverEmail = 'receiver_email';
  String receiverCreatedAt = 'receiver_createdAt';
  String callerId = "caller_id";
  String receiverId = "receiver_id";
  String callType = 'call_type';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print("db was null, now awaiting it");
    _db = await init();
    return _db;
  }

  @override
  void openDb(String dbName) => (databaseName = dbName);

  @override
  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  dynamic _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT,$callerEmail TEXT,$callerAboutMe TEXT,$receiverAboutMe TEXT,$receiverEmail TEXT,$receiverCreatedAt TEXT,$callerId TEXT,$receiverId TEXT, $callType TEXT)";
    // createTableQuery.sort((int a, int b) {
    //   int adate = a['timestamp']; //before -> var adate = a.expiry;
    //   int bdate = b['timestamp']; //before -> var bdate = b.expiry;
    //   return a.compareTo(b); //to get the order other way just switch `adate & bdate`
    // });
    await db.execute(createTableQuery);

    print("table created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  Future<int> deleteLogs(int logId) async {
    final dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$id = ?', whereArgs: <int>[logId]);
  }

  Future<void> updateLogs(Log log) async {
    var dbClient = await db;

    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: <int>[log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
          callerAboutMe,
          callerEmail,
          receiverAboutMe,
          receiverEmail,
          receiverCreatedAt,
          callerId,
          receiverId,
          callType
        ],
      );

      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
