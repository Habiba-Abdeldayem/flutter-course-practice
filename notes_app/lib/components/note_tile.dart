import 'package:flutter/material.dart';
import 'package:notes_app/components/note_popup.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final Function()? onEditPressed;
  final Function()? onDeletePressed;

  const NoteTile({
    super.key, required this.text, required this.onEditPressed, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: ListTile(
        title: Text(text),
        trailing: Builder(
          builder: (context) => IconButton(
            onPressed: () => showPopover(
              width: 100,
              height: 100,
              backgroundColor: Theme.of(context).colorScheme.surface,
              context: context,
               bodyBuilder: (context) => NotePopup(
                onEditPressed: onEditPressed,
                onDeletePressed: onDeletePressed,
               ),

          ), icon: Icon(Icons.more_vert)),
        )
      ),
    );
  }
}


// Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               onPressed: onEditPressed,
//               icon: Icon(Icons.edit),
//             ),
//             IconButton(
//               onPressed: onDeletePressed,
//               icon: Icon(Icons.delete),
//             ),
//           ],
//         ),