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

    final chunks = _chunksBox.getAll();
    chunks.sort(
      (a, b) => _cosineSimilarity(b.embedding, queryVector)
          .compareTo(_cosineSimilarity(a.embedding, queryVector)),
    );

    return chunks.take(limit).toList(growable: false);
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    final size = min(a.length, b.length);
    if (size == 0) {
      return 0;
    }

    var dot = 0.0;
    var normA = 0.0;
    var normB = 0.0;

    for (var i = 0; i < size; i++) {
      final ai = a[i];
      final bi = b[i];
      dot += ai * bi;
      normA += ai * ai;
      normB += bi * bi;
    }

    if (normA == 0 || normB == 0) {
      return 0;
    }

    return dot / (sqrt(normA) * sqrt(normB));
  }
}

class FakeEmbedder implements Embedder {
  @override
  Future<List<double>> embed(String text) async {
    final random = Random(text.hashCode);
    return List<double>.generate(384, (_) => random.nextDouble());
  }
}
