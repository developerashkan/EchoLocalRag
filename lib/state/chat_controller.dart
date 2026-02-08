import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/vector_search_service.dart';
import 'chat_prompt_builder.dart';
import 'chat_state.dart';

class ChatController extends StateNotifier<ChatState> {
  ChatController({
    required VectorSearchService searchService,
    required GemmaService gemmaService,
    ChatPromptBuilder? promptBuilder,
  })  : _searchService = searchService,
        _gemmaService = gemmaService,
        _promptBuilder = promptBuilder ?? const ChatPromptBuilder(),
        super(const ChatState());

  final VectorSearchService _searchService;
  final GemmaService _gemmaService;
  final ChatPromptBuilder _promptBuilder;

  Future<void> sendMessage(String message) async {
    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(role: ChatRole.user, content: message));

    state = state.copyWith(
      messages: updatedMessages,
      isStreaming: true,
      streamingText: '',
    );

    final snippets = await _searchService.searchNotes(message, limit: 3);
    final prompt = _promptBuilder.build(message, snippets);

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
