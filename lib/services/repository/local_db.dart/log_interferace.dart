import 'package:ChatApp/modal/log.dart';

abstract class LogInterface {
  void init();

   void addLogs(Log log);

  // returns a list of logs
  Future<List<Log>> getLogs();

  void deleteLogs(int logId);

  void close();
}