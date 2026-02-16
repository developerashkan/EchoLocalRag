class ChatMessage {
  ChatMessage({
    required this.role,
    required this.content,
  });

  final ChatRole role;
  final String content;
}

enum ChatRole { user, assistant }

class ChatState {
  const ChatState({
    this.messages = const [],
    this.streamingText = '',
    this.isStreaming = false,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final String streamingText;
  final bool isStreaming;
  final String? errorMessage;

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? streamingText,
    bool? isStreaming,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      streamingText: streamingText ?? this.streamingText,
      isStreaming: isStreaming ?? this.isStreaming,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
