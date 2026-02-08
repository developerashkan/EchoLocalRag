import 'dart:math';

import 'package:objectbox/objectbox.dart';

import '../models/note_chunk.dart';
import 'note_search_service.dart';

abstract class Embedder {
  Future<List<double>> embed(String text);
}

class VectorSearchService implements NoteSearchService {
  VectorSearchService({
    required Store store,
    required Embedder embedder,
  })  : _store = store,
        _embedder = embedder,
        _chunksBox = store.box<NoteChunk>();

  final Store _store;
  final Embedder _embedder;
  final Box<NoteChunk> _chunksBox;

  @override
  Future<List<NoteChunk>> searchNotes(String query, {int limit = 3}) async {
    final queryVector = await _embedder.embed(query);
    if (queryVector.isEmpty) {
      return [];
    }

    final vectorQuery = _chunksBox
        .query(NoteChunk_.embedding.nearestNeighbors(queryVector, limit))
        .build();

    final results = vectorQuery.find();
    vectorQuery.close();

    return results;
  }
}

class FakeEmbedder implements Embedder {
  @override
  Future<List<double>> embed(String text) async {
    final random = Random(text.hashCode);
    return List<double>.generate(384, (_) => random.nextDouble());
  }
}
