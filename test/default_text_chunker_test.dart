import 'package:flutter_test/flutter_test.dart';

import 'package:echo_local_rag/services/text_chunker.dart';

void main() {
  test('DefaultTextChunker splits words by max token count', () {
    const chunker = DefaultTextChunker(maxTokens: 3);
    final chunks = chunker.chunk('one two  three   four five');

    expect(chunks, ['one two three', 'four five']);
  });

  test('DefaultTextChunker ignores empty input', () {
    const chunker = DefaultTextChunker(maxTokens: 2);
    final chunks = chunker.chunk('   ');

    expect(chunks, isEmpty);
  });
}
