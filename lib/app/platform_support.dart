import 'package:flutter/foundation.dart';

/// Describes the Flutter runtime platform in a human readable form.
String currentPlatformLabel() {
  if (kIsWeb) return 'web';

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'android';
    case TargetPlatform.iOS:
      return 'ios';
    case TargetPlatform.macOS:
      return 'macos';
    case TargetPlatform.windows:
      return 'windows';
    case TargetPlatform.linux:
      return 'linux';
    case TargetPlatform.fuchsia:
      return 'fuchsia';
  }
}

/// Platforms we explicitly support in this package.
const Set<String> supportedPlatforms = {
  'android',
  'ios',
  'web',
  'windows',
  'linux',
  'macos',
};

bool isCurrentPlatformSupported() {
  return supportedPlatforms.contains(currentPlatformLabel());
}
