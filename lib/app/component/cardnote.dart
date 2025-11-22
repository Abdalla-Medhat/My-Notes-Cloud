import 'package:api_php_mysql_training/constant/api_links.dart';
import 'package:api_php_mysql_training/models/notesmodel.dart';
import 'package:flutter/material.dart';

class Cardnote extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onTap;
  final NotesModel notesModel;
  const Cardnote({
    super.key,
    this.onPressed,
    required this.onTap,
    required this.notesModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: notesModel.noteImg != null
                  ? Image.network(
                      "$imgLink${notesModel.noteImg}",
                      width: 125,
                      height: 125,
                      fit: BoxFit.contain,
                    )
                  : Image.asset("images/note_image.png", width: 100),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(
                  "${notesModel.noteTitle}",
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${notesModel.noteContent}",
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
