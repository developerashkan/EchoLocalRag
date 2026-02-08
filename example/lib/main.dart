import 'package:echo_local_rag/echo_local_rag.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    EchoApp(
      dependencies: AppDependencies(
        searchService: ExampleSearchService(),
        gemmaService: FakeGemmaService(),
        statusMessage: 'Demo mode is active.',
      ),
    ),
  );
}

class ExampleSearchService implements NoteSearchService {
  @override
  Future<List<NoteChunk>> searchNotes(String query, {int limit = 3}) async {
    return List<NoteChunk>.generate(
      limit,
      (index) => NoteChunk(
        noteId: index + 1,
        content: 'Sample note snippet ${index + 1} for "$query".',
        embedding: List<double>.filled(384, 0.0),
      ),
    );
  }
}
