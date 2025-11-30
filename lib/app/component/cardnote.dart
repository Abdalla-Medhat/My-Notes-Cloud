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
        color: Colors.pinkAccent,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: notesModel.noteImg != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "$imgLink${notesModel.noteImg}",
                          width: 125,
                          height: 125,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(35),
                      child: Image.asset(
                        "images/note_image.png", // This Image has png background
                        width: 125,
                        height: 125,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(
                  "${notesModel.noteTitle}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${notesModel.noteContent}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.blueGrey),
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
