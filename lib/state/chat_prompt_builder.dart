import '../models/note_chunk.dart';

class ChatPromptBuilder {
  const ChatPromptBuilder({
    this.systemPrompt = _defaultSystemPrompt,
  });

  final String systemPrompt;

  String build(String query, List<NoteChunk> snippets) {
    final context = snippets.map((chunk) => '- ${chunk.content}').join('\n');
    return '$systemPrompt\nCONTEXT: $context\nQUESTION: $query';
  }
}

const _defaultSystemPrompt =
    'You are Echo, a private assistant. Use the following CONTEXT from the user\'s notes to answer the question. If the answer isn\'t in the context, say you don\'t know.';
