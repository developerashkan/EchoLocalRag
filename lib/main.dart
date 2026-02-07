import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/chat_screen.dart';
import 'services/vector_search_service.dart';
import 'state/chat_controller.dart';

void main() {
  runApp(const EchoApp());
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        chatControllerProvider.overrideWith((ref) {
          final searchService = VectorSearchService(
            store: throw UnimplementedError('Provide ObjectBox Store'),
            embedder: FakeEmbedder(),
          );
          return ChatController(
            searchService: searchService,
            gemmaService: FakeGemmaService(),
          );
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF8F8F8),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
