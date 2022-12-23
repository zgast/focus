import 'dart:convert';
import 'dart:io';

class DB {
  static var _tasks = {};
  static var _done = {};

  static const _tasksPath = '/opt/focus/db/tasks.json';
  static const _donePath = '/opt/focus/db/done.json';

  static void readIn() {
    var contents = File(_tasksPath).readAsStringSync();
    _tasks = jsonDecode(contents);

    contents = File(_donePath).readAsStringSync();
    _done = jsonDecode(contents);
  }

  static void addTask(Map tasks) {
    _tasks = tasks;
    writeTo(_tasksPath, tasks);
  }

  static void addDone(MapEntry entry) {
    _tasks.remove(entry.key);
    _done[entry.key] = entry.value;

    writeTo(_tasksPath, _tasks);
    writeTo(_donePath, _done);
  }

  static void writeTo(String file, Map map) async {
    String rawJson = jsonEncode(map);

    File(file).writeAsString(rawJson);
  }

  static Map getTasks() {
    return _tasks;
  }

  static Map getDone() {
    return _done;
  }
}
