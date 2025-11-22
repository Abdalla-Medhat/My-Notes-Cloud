class NotesModel {
  int? noteId;
  String? noteTitle;
  String? noteContent;
  String? noteImg;
  int? userNote;

  NotesModel({
    this.noteId,
    this.noteTitle,
    this.noteContent,
    this.noteImg,
    this.userNote,
  });

  NotesModel.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'];
    noteTitle = json['note_title'];
    noteContent = json['note_content'];
    noteImg = json['note_img'];
    userNote = json['user_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['note_id'] = noteId;
    data['note_title'] = noteTitle;
    data['note_content'] = noteContent;
    data['note_img'] = noteImg;
    data['user_note'] = userNote;
    return data;
  }
}
