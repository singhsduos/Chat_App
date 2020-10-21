import 'package:ChatApp/modal/log.dart';

abstract class LogInterface {
  void openDb(String dbName);
  void init();

  void addLogs(Log log);

  // returns a list of logs
  Future<List<Log>> getLogs();

  Future<void> deleteLogs(int logId);

  void close();
}
