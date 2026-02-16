import 'package:echo_local_rag/app/platform_support.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supported platform set contains all primary flutter targets', () {
    expect(
      supportedPlatforms,
      containsAll(<String>['android', 'ios', 'web', 'windows', 'linux', 'macos']),
    );
  });
}
