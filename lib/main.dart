import 'package:flutter/material.dart';

import 'app/app_dependencies.dart';
import 'app/echo_app.dart';

void main() {
  runApp(
    const EchoApp(
      dependencies: AppDependencies(
        statusMessage:
            'Wire up your ObjectBox store, embedder, and Gemma runtime to start.',
      ),
    ),
  );
}
