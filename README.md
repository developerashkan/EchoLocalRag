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
