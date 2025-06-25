import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newTextController = TextEditingController();
  final box = Hive.box("mybox");
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    if (box.get("TodoList") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  void saveTask() {
    setState(() {
      db.todoList.add([newTextController.text, false]);
      newTextController.text = "";
      Navigator.pop(context);
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          textController: newTextController,
          onSave: saveTask,
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text(
          "Todo App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.todoList[index][0],
            isCompleted: db.todoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          createNewTask();
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:todo_app/util/dialog_box.dart';
// import 'package:todo_app/util/todo_tile.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final newTextController = TextEditingController();
//   final _myBox = Hive.openBox("todo App box");
//   List todoList = [
//     ["Watch tutorial", false],
//     ["gym", true],
//   ];

//   void checkBoxChanged(bool? value, int index) {
//     setState(() {
//       todoList[index][1] = !todoList[index][1];
//     });
//   }

//   void saveTask() {
//     setState(() {
//       todoList.add([newTextController.text, false]);
//       newTextController.text = "";
//       Navigator.pop(context);
//     });
//   }

//   void createNewTask() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return DialogBox(
//           textController: newTextController,
//           onSave: saveTask,
//           onCancel: () => Navigator.pop(context),
//         );
//       },
//     );
//   }

//   void deleteTask(int index) {
//     setState(() {
//       todoList.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.yellow[200],
//       appBar: AppBar(
//         title: Text("App bar"),
//         // backgroundColor: Colors.yellow[200],
//       ),
//       body: ListView.builder(
//         itemCount: todoList.length,
//         itemBuilder: (context, index) {
//           return TodoTile(
//             taskName: todoList[index][0],
//             isCompleted: todoList[index][1],
//             onChanged: (value) => checkBoxChanged(value, index),
//             deleteFunction: (context) => deleteTask(index),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           createNewTask();
//         },
//       ),
//     );
//   }
// }
