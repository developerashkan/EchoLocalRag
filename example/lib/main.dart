import 'dart:typed_data';

import 'package:echo_local_rag/echo_local_rag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _gemmaModelAsset = 'assets/models/gemma-2b-it-gpu-int4.bin';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final modelBytes = await _tryLoadGemmaModelAsset();
  final modelDetected = modelBytes != null && modelBytes.isNotEmpty;

  runApp(
    EchoApp(
      dependencies: AppDependencies(
        searchService: ExampleSearchService(),
        gemmaService: DemoGemmaService(modelDetected: modelDetected),
        statusMessage: modelDetected
            ? 'Loaded $_gemmaModelAsset (${modelBytes.lengthInBytes} bytes).'
            : 'Missing $_gemmaModelAsset. Add the model file under example/assets/models/.',
      ),
    ),
  );
}

Future<ByteData?> _tryLoadGemmaModelAsset() async {
  try {
    return await rootBundle.load(_gemmaModelAsset);
  } catch (_) {
    return null;
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

class DemoGemmaService implements GemmaService {
  DemoGemmaService({required this.modelDetected});

  final bool modelDetected;

  @override
  Stream<String> streamCompletion(String prompt) async* {
    final prefix = modelDetected
        ? 'Gemma asset found. Demo response: '
        : 'Gemma asset missing. Demo response: ';
    final response = '$prefix I found context related to "$prompt".';

    for (final char in response.split('')) {
      await Future<void>.delayed(const Duration(milliseconds: 18));
      yield char;
    }
  }
}
