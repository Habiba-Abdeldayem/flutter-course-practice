import 'package:hive/hive.dart';

class TodoDatabase {
  List todoList = [];

  final _myBox = Hive.box("mybox");

  void createInitialData() {
    todoList = [
      ["Watch tutorial", false],
      ["gym", true],
    ];
  }

  void loadData() {
    todoList = _myBox.get("TodoList");
  }

  void updateDatabase() {
    _myBox.put("TodoList", todoList);
  }
}
