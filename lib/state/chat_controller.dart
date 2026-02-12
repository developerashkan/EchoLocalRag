import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/note_search_service.dart';
import 'chat_prompt_builder.dart';
import 'chat_state.dart';

final noteSearchServiceProvider = Provider<NoteSearchService>((ref) {
  throw UnimplementedError('Override noteSearchServiceProvider in ProviderScope');
});

final gemmaServiceProvider = Provider<GemmaService>((ref) {
  throw UnimplementedError('Override gemmaServiceProvider in ProviderScope');
});

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);

class ChatController extends Notifier<ChatState> {
  ChatController({
    ChatPromptBuilder? promptBuilder,
  }) : _promptBuilder = promptBuilder ?? const ChatPromptBuilder();

  late final NoteSearchService _searchService;
  late final GemmaService _gemmaService;
  final ChatPromptBuilder _promptBuilder;

  @override
  ChatState build() {
    _searchService = ref.read(noteSearchServiceProvider);
    _gemmaService = ref.read(gemmaServiceProvider);
    return const ChatState();
  }

  Future<void> sendMessage(String message) async {
    if (state.isStreaming) {
      return;
    }

    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(role: ChatRole.user, content: trimmed));

    state = state.copyWith(
      messages: updatedMessages,
      isStreaming: true,
      streamingText: '',
      clearError: true,
    );

    try {
      final snippets = await _searchService.searchNotes(trimmed, limit: 3);
      final prompt = _promptBuilder.build(trimmed, snippets);

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
    } catch (error) {
      state = state.copyWith(
        isStreaming: false,
        streamingText: '',
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(clearError: true);
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
