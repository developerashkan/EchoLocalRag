import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/chat_controller.dart';
import '../state/chat_state.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatState>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final notifier = ref.read(chatControllerProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: 300.ms,
        curve: Curves.easeOut,
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Echo',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ErrorBanner(
                  message: state.errorMessage!,
                  onDismiss: notifier.clearError,
                ),
              ),
            Expanded(
              child: state.messages.isEmpty && !state.isStreaming
                  ? const _EmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount:
                          state.messages.length + (state.isStreaming ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.messages.length &&
                            state.isStreaming) {
                          return _MessageBubble(
                            role: ChatRole.assistant,
                            content: state.streamingText,
                          );
                        }
                        final message = state.messages[index];
                        return _MessageBubble(
                          role: message.role,
                          content: message.content,
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF111111),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask Echo about your notes...',
                        hintStyle: GoogleFonts.inter(color: Colors.black38),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _SendButton(
                    isLoading: state.isStreaming,
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isEmpty || state.isStreaming) {
                        return;
                      }
                      _controller.clear();
                      notifier.sendMessage(text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Color(0xFFB32020)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF7A1C1C),
              ),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, size: 18),
            color: const Color(0xFF7A1C1C),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 42,
              color: Color(0xFF111111),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask Echo about your notes',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Echo searches your local knowledge base and answers offline.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF4D4D4D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: 240.ms,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(isLoading ? 26 : 16),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: 200.ms,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
          ),
        ),
      )
          .animate(target: isLoading ? 1 : 0)
          .fadeOut(duration: 400.ms, delay: 200.ms)
          .then()
          .fadeIn(duration: 400.ms),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.role,
    required this.content,
  });

  final ChatRole role;
  final String content;

  @override
  Widget build(BuildContext context) {
    final isUser = role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF111111) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isUser ? Colors.white : const Color(0xFF111111),
          ),
        ),
      ),
    );
  }
}
