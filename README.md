# Echo Local RAG

Echo is a 100% offline, local-first RAG (Retrieval Augmented Generation) Flutter app that combines fast on-device embeddings with a lightweight Gemma model for summarization. The architecture keeps private notes on-device and performs vector search using ObjectBox's HNSW index.

## Trend Fit
**Offline-First AI (Edge AI)**: privacy-first RAG means journals never leave the device while still offering high-quality answers.

## Core Architecture
- **LLM Engine**: `flutter_gemma` running `gemma-2b-it-gpu-int4.bin`.
- **Vector Database**: `objectbox` with HNSW vector search.
- **Embeddings**: `tflite_flutter` (or MediaPipe Text Embedder) for local embeddings.
- **State**: Riverpod for async state management.

## Prompt Template
```text
You are Echo, a private assistant. Use the following CONTEXT from the user's notes to answer the question. If the answer isn't in the context, say you don't know.
CONTEXT: {inserted_note_snippets}
QUESTION: {user_query}
```

## Key Files
- `lib/models/note.dart`: ObjectBox Note entity.
- `lib/models/note_chunk.dart`: Vectorized note chunks with HNSW index.
- `lib/services/ingestion_service.dart`: Background isolate ingestion pipeline (chunking + embedding).
- `lib/services/vector_search_service.dart`: `searchNotes` logic.
- `lib/state/chat_controller.dart`: RAG prompt assembly + Gemma streaming.
- `lib/screens/chat_screen.dart`: Scientific minimalist UI + streaming.
- `example/`: Pub.dev-style example app showcasing the chat flow.

## Example App (All Platforms)
The `example/` app is a minimal Flutter shell that can be run on Android, iOS, Web, macOS, Windows, and Linux once the platform tooling is available on your machine.

## Next Steps
1. Replace the `FakeEmbedder` with a real MediaPipe/TFLite embedder.
2. Wire ObjectBox `Store` into the provider override in `main.dart`.
3. Replace `FakeGemmaService` with `flutter_gemma` streaming inference.

## Prompt to Paste into Claude 3.7 or Gemini 1.5 Pro
"""
Act as a Senior Flutter Architect. I want you to build the core architecture for 'Echo', a 100% offline, local-first RAG (Retrieval Augmented Generation) application.

1. The Tech Stack (Strict Constraints):

LLM Engine: Use flutter_gemma (powered by MediaPipe) to run the gemma-2b-it-gpu-int4.bin model.

Vector Database: Use objectbox (specifically its new 'Vector Search' feature with HNSW support).

Embeddings: Use tflite_flutter (or the MediaPipe Text Embedder task) to convert note text into vector floats locally. Do not use an API for this.

State: Use riverpod for asynchronous state management.

2. Core Features to Implement:

The 'Ingestion' Pipeline: Create a background isolate that watches user notes. When a note is saved, chunk the text into 512-token segments, generate embeddings locally, and store them in objectbox with a link back to the original Note ID.

The 'Neural Search' Service: Write a function searchNotes(String query) that converts the query to a vector, performs a generic 'Nearest Neighbor' search in ObjectBox, and returns the top 3 most relevant note snippets.

The 'RAG' Prompt Construction: Create a system prompt template:

Plaintext
You are Echo, a private assistant. Use the following CONTEXT from the user's notes to answer the question. If the answer isn't in the context, say you don't know.
CONTEXT: {inserted_note_snippets}
QUESTION: {user_query}
Streaming Response: Connect the flutter_gemma response stream to the UI so text appears character-by-character.

3. UI & Aesthetic:

Theme: 'Scientific Minimalist'. Use a monochromatic palette (Off-white background, Jet black text).

Typography: Use 'JetBrains Mono' for code blocks and 'Inter' for prose.

Animations: Use flutter_animate to make the 'Send' button morph into a loading spinner, then fade out as text streams in.

Deliverable: Provide the full pubspec.yaml dependencies, the Note entity model (annotated for ObjectBox), the VectorSearchService class, and the main ChatScreen widget code.
"""
