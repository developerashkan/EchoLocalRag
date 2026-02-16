import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/chat_screen.dart';
import '../screens/setup_screen.dart';
import '../state/chat_controller.dart';
import 'app_dependencies.dart';

class EchoApp extends StatelessWidget {
  const EchoApp({
    super.key,
    required this.dependencies,
  });

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        if (dependencies.isConfigured)
          noteSearchServiceProvider.overrideWithValue(
            dependencies.searchService!,
          ),
        if (dependencies.isConfigured)
          gemmaServiceProvider.overrideWithValue(
            dependencies.gemmaService!,
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF8F8F8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF111111),
          ),
        ),
        home: dependencies.isConfigured
            ? const ChatScreen()
            : SetupScreen(statusMessage: dependencies.statusMessage),
      ),
    );
  }
}
