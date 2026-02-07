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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final notifier = ref.read(chatControllerProvider.notifier);

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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: state.messages.length + (state.isStreaming ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.messages.length && state.isStreaming) {
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
