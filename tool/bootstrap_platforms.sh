#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is not installed or not on PATH." >&2
  echo "Install Flutter and re-run this script to generate iOS/Web/Desktop project files." >&2
  exit 1
fi

flutter create --platforms=android,ios,web,windows,linux,macos .
echo "Platform scaffolding generated for Android, iOS, Web, Windows, Linux, and macOS."
