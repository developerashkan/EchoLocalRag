import 'package:echo_local_rag/echo_local_rag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const EchoExampleApp());
}

class EchoExampleApp extends StatelessWidget {
  const EchoExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        chatControllerProvider.overrideWith((ref) {
          return ChatController(
            searchService: ExampleSearchService(),
            gemmaService: FakeGemmaService(),
          );
        }),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatScreen(),
      ),
    );
  }
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
