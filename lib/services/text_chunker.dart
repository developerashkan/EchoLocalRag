abstract class TextChunker {
  const TextChunker();

  List<String> chunk(String text);
}

class DefaultTextChunker extends TextChunker {
  const DefaultTextChunker({this.maxTokens = 512});

  final int maxTokens;

  @override
  List<String> chunk(String text) {
    final words = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    final chunks = <String>[];
    final buffer = <String>[];

    for (final word in words) {
      buffer.add(word);
      if (buffer.length >= maxTokens) {
        chunks.add(buffer.join(' '));
        buffer.clear();
      }
    }

    if (buffer.isNotEmpty) {
      chunks.add(buffer.join(' '));
    }

    return chunks;
  }
}
