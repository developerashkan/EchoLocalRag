import '../services/note_search_service.dart';
import '../state/chat_controller.dart';

class AppDependencies {
  const AppDependencies({
    this.searchService,
    this.gemmaService,
    this.statusMessage =
        'Echo is not configured yet. Connect your local models and note store.',
  });

  final NoteSearchService? searchService;
  final GemmaService? gemmaService;
  final String statusMessage;

  bool get isConfigured => searchService != null && gemmaService != null;

  AppDependencies copyWith({
    NoteSearchService? searchService,
    GemmaService? gemmaService,
    String? statusMessage,
  }) {
    return AppDependencies(
      searchService: searchService ?? this.searchService,
      gemmaService: gemmaService ?? this.gemmaService,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
