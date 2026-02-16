import 'package:flutter/material.dart';

import 'app/bootstrap_dependencies.dart';
import 'app/echo_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await bootstrapDependencies();

  runApp(EchoApp(dependencies: dependencies));
}
