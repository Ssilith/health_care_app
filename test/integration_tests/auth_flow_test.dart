import 'package:flutter_test/flutter_test.dart';
import 'utils/common_actions.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('login + logout', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();
      await login(tester);
      await logout(tester);
    }, name: 'integ_auth_login_logout');
  });
}
