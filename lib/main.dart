import 'package:flutter/material.dart';

import 'app/app_dependencies.dart';
import 'app/echo_app.dart';
import 'app/platform_support.dart';

void main() {
  runApp(
    EchoApp(
      dependencies: AppDependencies(
        statusMessage:
            'Running on ${currentPlatformLabel()}. Wire up your ObjectBox store, embedder, and Gemma runtime to start.',
      ),
    ),
  );
}
