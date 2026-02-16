import 'package:echo_local_rag/app/app_dependencies.dart';
import 'package:echo_local_rag/app/echo_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows setup screen when dependencies are missing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const EchoApp(
        dependencies: AppDependencies(
          statusMessage: 'setup required',
        ),
      ),
    );

    expect(find.text('Echo Setup'), findsOneWidget);
    expect(find.text('setup required'), findsOneWidget);
  });
}
