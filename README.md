# Echo Local RAG

Echo is a 100% offline, local-first RAG (Retrieval Augmented Generation) Flutter app that combines fast on-device embeddings with a lightweight Gemma model for summarization. The architecture keeps private notes on-device and performs vector search using ObjectBox's HNSW index.

## Trend Fit
**Offline-First AI (Edge AI)**: privacy-first RAG means journals never leave the device while still offering high-quality answers.

## Core Architecture
- **LLM Engine**: `flutter_gemma` running `gemma-2b-it-gpu-int4.bin`.
- **Vector Database**: `objectbox` with HNSW vector search.
- **Embeddings**: `tflite_flutter` (or MediaPipe Text Embedder) for local embeddings.
- **State**: Riverpod for async state management.


## Platform Support
Echo now targets **Android, iOS, Web, macOS, Windows, and Linux** from the same Flutter codebase.

To generate or refresh native platform scaffolding in environments with Flutter installed:

```bash
flutter create --platforms=android,ios,web,windows,linux,macos .
```

## Production Setup
Echo ships as a package with an embeddable `EchoApp`. Inject your ObjectBox-backed
search service and Gemma runtime via `AppDependencies` to enable the chat UI. If
dependencies are missing, Echo shows a setup screen instead of crashing.

```dart
runApp(
  EchoApp(
    dependencies: AppDependencies(
      searchService: yourSearchService,
      gemmaService: yourGemmaService,
    ),
  ),
);
```

### Where this should be added: app code vs "phone"
- Put `runApp(EchoApp(...))` in your Flutter app entrypoint (`lib/main.dart` in your app project).
- Put the model file (`gemma-2b-it-gpu-int4.bin`) on the device at runtime (for example by
  shipping it as an asset and copying it to app documents/cache storage on first launch).
- In short: **wiring is in app code**, **model binary lives on the phone/device filesystem**.

### What to use for a free `searchService`
`AppDependencies.searchService` expects a `NoteSearchService` implementation. The easiest
free/OSS option in this repo is:

- `VectorSearchService` (`lib/services/vector_search_service.dart`) + ObjectBox community edition,
  with a local embedder implementation.

That keeps retrieval fully offline and avoids paid APIs.


### Zero-config model bootstrap (default app)
The default `lib/main.dart` now auto-detects a Gemma asset at startup. To enable chat without writing any wiring code:

1. Create `assets/models/` in the app project.
2. Add your model file as either:
   - `assets/models/gemma-2b-it-gpu-int4.bin`, or
   - `assets/models/gemma.bin`
3. Ensure `pubspec.yaml` includes `assets/models/` under `flutter.assets`.
4. Restart the app.

If a valid file is found, Echo switches directly to chat mode.
If not, Echo shows setup guidance.

## Developer Integration Guide

### 1) Implement a Gemma runtime service
Create a class that implements `GemmaService` and streams tokens from `flutter_gemma`.

```dart
class FlutterGemmaService implements GemmaService {
  FlutterGemmaService(this.modelPath);

  final String modelPath;

  @override
  Stream<String> streamCompletion(String prompt) async* {
    // Pseudocode: initialize flutter_gemma with modelPath once,
    // send prompt, then yield streamed tokens.
  }
}
```

### 2) Implement (or reuse) search
Use `VectorSearchService` with ObjectBox and an `Embedder` implementation that runs on-device
(for example with `tflite_flutter` or MediaPipe).

### 3) Wire dependencies in `main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final searchService = await buildSearchService();
  final gemmaService = await buildGemmaService();

  runApp(
    EchoApp(
      dependencies: AppDependencies(
        searchService: searchService,
        gemmaService: gemmaService,
      ),
    ),
  );
}
```

### 4) Keep fallback mode for unconfigured builds
If you do not pass both services, Echo intentionally shows a setup screen. This is useful during
incremental development and CI smoke tests.

## Prompt Template
```text
You are Echo, a private assistant. Use the following CONTEXT from the user's notes to answer the question. If the answer isn't in the context, say you don't know.
CONTEXT: {inserted_note_snippets}
QUESTION: {user_query}
```
