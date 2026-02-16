import 'package:echo_local_rag/app/app_dependencies.dart';
import 'package:echo_local_rag/app/echo_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const EchoApp(
        dependencies: AppDependencies(
          searchService: null,
          gemmaService: null,
        ),
      ),
    );
   // fix
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
