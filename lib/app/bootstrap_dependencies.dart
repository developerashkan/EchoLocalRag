import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../models/note_chunk.dart';
import '../services/note_search_service.dart';
import '../state/chat_controller.dart';
import 'app_dependencies.dart';

const List<String> _gemmaAssetCandidates = [
  'assets/models/gemma-2b-it-gpu-int4.bin',
  'assets/models/gemma.bin',
];

Future<AppDependencies> bootstrapDependencies() async {
  final modelAsset = await _detectGemmaAsset();

  if (modelAsset == null) {
    return const AppDependencies(
      statusMessage:
          'Gemma model not found. Add a .bin file under assets/models/ (for example assets/models/gemma-2b-it-gpu-int4.bin) and restart the app.',
    );
  }

  return AppDependencies(
    searchService: const EmptySearchService(),
    gemmaService: AssetAwareGemmaService(modelAssetPath: modelAsset.path),
    statusMessage:
        'Detected ${modelAsset.path} (${modelAsset.sizeInBytes} bytes). Echo is ready.',
  );
}

Future<_DetectedModelAsset?> _detectGemmaAsset() async {
  for (final candidate in _gemmaAssetCandidates) {
    try {
      final bytes = await rootBundle.load(candidate);
      if (bytes.lengthInBytes > 0) {
        return _DetectedModelAsset(candidate, bytes);
      }
    } catch (_) {
      // Keep checking the next candidate.
    }
  }

  return null;
}

class _DetectedModelAsset {
  _DetectedModelAsset(this.path, ByteData bytes) : sizeInBytes = bytes.lengthInBytes;

  final String path;
  final int sizeInBytes;
}

class EmptySearchService implements NoteSearchService {
  const EmptySearchService();

  @override
  Future<List<NoteChunk>> searchNotes(String query, {int limit = 3}) async =>
      const [];
}

class AssetAwareGemmaService implements GemmaService {
  AssetAwareGemmaService({required this.modelAssetPath});

  final String modelAssetPath;

  @override
  Stream<String> streamCompletion(String prompt) async* {
    final response =
        'Model detected at $modelAssetPath. Connect flutter_gemma runtime to this asset path for full production inference. Prompt received: "$prompt".';

    for (final char in response.split('')) {
      await Future<void>.delayed(const Duration(milliseconds: 8));
      yield char;
    }
  }
}
