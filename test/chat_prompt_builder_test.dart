import 'package:flutter_test/flutter_test.dart';

import 'package:echo_local_rag/models/note_chunk.dart';
import 'package:echo_local_rag/state/chat_prompt_builder.dart';

void main() {
  test('ChatPromptBuilder formats context and query', () {
    const builder = ChatPromptBuilder(systemPrompt: 'SYSTEM');
    final snippets = [
      NoteChunk(noteId: 1, content: 'First snippet', embedding: const [0.1]),
      NoteChunk(noteId: 1, content: 'Second snippet', embedding: const [0.2]),
    ];

    final prompt = builder.build('What is Echo?', snippets);

    expect(
      prompt,
      'SYSTEM\nCONTEXT: - First snippet\n- Second snippet\nQUESTION: What is Echo?',
    );
  });
}
