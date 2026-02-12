import 'dart:isolate';

import 'package:objectbox/objectbox.dart';

import '../models/note.dart';
import '../models/note_chunk.dart';
import 'text_chunker.dart';
import 'vector_search_service.dart';

class IngestionService {
  IngestionService({
    required Store store,
    required Embedder embedder,
    TextChunker? chunker,
  })  : _store = store,
        _embedder = embedder,
        _chunker = chunker ?? const DefaultTextChunker(),
        _chunkBox = store.box<NoteChunk>();

  final Store _store;
  final Embedder _embedder;
  final TextChunker _chunker;
  final Box<NoteChunk> _chunkBox;

  Future<void> ingest(Note note) async {
    final chunks = await Isolate.run(() => _chunker.chunk(note.body));
    for (final chunk in chunks) {
      final embedding = await _embedder.embed(chunk);
      final noteChunk = NoteChunk(
        noteId: note.id,
        content: chunk,
        embedding: embedding,
      );
      _chunkBox.put(noteChunk);
    }
  }
}
