import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note_chunk.dart';
import '../services/vector_search_service.dart';
import 'chat_state.dart';

const _systemPrompt =
    'You are Echo, a private assistant. Use the following CONTEXT from the user\'s notes to answer the question. If the answer isn\'t in the context, say you don\'t know.';

class ChatController extends StateNotifier<ChatState> {
  ChatController({
    required NoteSearchService searchService,
    required GemmaService gemmaService,
  })  : _searchService = searchService,
        _gemmaService = gemmaService,
        super(const ChatState());

  final NoteSearchService _searchService;
  final GemmaService _gemmaService;

  Future<void> sendMessage(String message) async {
    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(role: ChatRole.user, content: message));

    state = state.copyWith(
      messages: updatedMessages,
      isStreaming: true,
      streamingText: '',
    );

    final snippets = await _searchService.searchNotes(message, limit: 3);
    final prompt = _buildPrompt(message, snippets);

    final buffer = StringBuffer();
    await for (final token in _gemmaService.streamCompletion(prompt)) {
      buffer.write(token);
      state = state.copyWith(streamingText: buffer.toString());
    }

    final assistantMessage = ChatMessage(
      role: ChatRole.assistant,
      content: buffer.toString(),
    );

    state = state.copyWith(
      messages: [...state.messages, assistantMessage],
      isStreaming: false,
      streamingText: '',
    );
  }

  String _buildPrompt(String query, List<NoteChunk> snippets) {
    final context = snippets.map((chunk) => '- ${chunk.content}').join('\n');
    return '$_systemPrompt\nCONTEXT: $context\nQUESTION: $query';
  }
}

abstract class GemmaService {
  Stream<String> streamCompletion(String prompt);
}

class FakeGemmaService implements GemmaService {
  @override
  Stream<String> streamCompletion(String prompt) async* {
    final response = 'Echo (offline): I found context related to "$prompt".';
    for (final char in response.split('')) {
      await Future<void>.delayed(const Duration(milliseconds: 18));
      yield char;
    }
  }
}
