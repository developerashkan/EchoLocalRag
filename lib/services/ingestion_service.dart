import 'dart:isolate';

import 'package:objectbox/objectbox.dart';

import '../models/note.dart';
import '../models/note_chunk.dart';
import 'vector_search_service.dart';

typedef Chunker = List<String> Function(String text);

class IngestionService {
  IngestionService({
    required Store store,
    required Embedder embedder,
    Chunker? chunker,
  })  : _store = store,
        _embedder = embedder,
        _chunker = chunker ?? _defaultChunker,
        _chunkBox = store.box<NoteChunk>();

  final Store _store;
  final Embedder _embedder;
  final Chunker _chunker;
  final Box<NoteChunk> _chunkBox;

  Future<void> ingest(Note note) async {
    final chunks = await Isolate.run(() => _chunker(note.body));
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

List<String> _defaultChunker(String text) {
  const maxTokens = 512;
  final words = text.split(RegExp(r'\s+'));
  final chunks = <String>[];
  final buffer = <String>[];

  for (final word in words) {
    buffer.add(word);
    if (buffer.length >= maxTokens) {
      chunks.add(buffer.join(' '));
      buffer.clear();
    }
  }

  if (buffer.isNotEmpty) {
    chunks.add(buffer.join(' '));
  }

  return chunks;
}
