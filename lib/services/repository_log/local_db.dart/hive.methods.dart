import 'dart:io';
import 'package:ChatApp/services/repository_log/local_db.dart/log_interferace.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ChatApp/modal/log.dart';

class HiveMethods implements LogInterface {
  String _hiveBox = '';

    @override
  void openDb(String dbName) =>( _hiveBox = dbName);
 
  @override
  init() async {
    final Directory d = await getApplicationDocumentsDirectory();
    Hive.init(d.path);
  }

 

  @override
  Future<int> addLogs(Log log) async {
    final Box box = await Hive.openBox<String>(_hiveBox);
    var logMap = log.toMap(log);
    int idOfInput = await box.add(logMap);
    Hive.close();
    return idOfInput;
  }

  @override
  dynamic updateLogs(int i, Log newLog) async {
    var box = await Hive.openBox<dynamic>(_hiveBox);
    var newLogMap = newLog.toMap(newLog);
    box.putAt(i, newLogMap);
    close();
  }

  @override
  Future<List<Log>> getLogs() async {
    final Box box = await Hive.openBox<String>(_hiveBox);
    List<Log> list = [];

    for (int i = 0; i < box.length; i++) {
      Map<String, dynamic> logMap = box.getAt(i) as Map<String, dynamic>;
      list.add(
        Log.fromMap(
          logMap,
        ),
      );
    }

    return list;
  }

  @override
  deleteLogs(int logId) async {
    final Box box = await Hive.openBox<String>(_hiveBox);
    await box.deleteAt(logId);
  }

  

  @override
  close() => Hive.close();
}
