import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController textController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.textController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "new task name",
        ),
      ),
      actions: [
        OutlinedButton(onPressed: onCancel, child: Text("Cancel")),
        FilledButton(onPressed: onSave, child: Text("Save")),
      ],
    );
  }
}
