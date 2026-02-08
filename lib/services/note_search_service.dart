import '../models/note_chunk.dart';

abstract class NoteSearchService {
  Future<List<NoteChunk>> searchNotes(String query, {int limit});
}
