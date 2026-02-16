# Echo Local RAG Example

This example app wires the package into a minimal Flutter UI. It is intentionally platform-agnostic and can be run on Android, iOS, Web, macOS, Windows, and Linux once the corresponding Flutter toolchains are installed.

## Model asset setup

The example expects the Gemma binary at:

`example/assets/models/gemma-2b-it-gpu-int4.bin`

If the asset is missing, the app still runs in demo mode and shows a status message explaining what path to add.

```bash
flutter run
```
