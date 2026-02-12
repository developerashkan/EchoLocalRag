import 'package:objectbox/objectbox.dart';

import 'note.dart';

@Entity()
class NoteChunk {
  @Id()
  int id = 0;

  int noteId;

  String content;

  @Property(type: PropertyType.floatVector)
  List<double> embedding;

  final note = ToOne<Note>();

  NoteChunk({
    this.id = 0,
    required this.noteId,
    required this.content,
    required this.embedding,
  }) {
    note.targetId = noteId;
  }
}
