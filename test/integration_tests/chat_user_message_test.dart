import 'package:flutter_test/flutter_test.dart';

import '../utils/benchmark_helper.dart';
import 'utils/common_actions.dart';

void main() {
  testWidgets('chat send / receive', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();

      await login(tester);
      await tester.tap(find.text('Chat bot'));
      await tester.pumpAndSettle();

      await sendChatMessage(tester);
    }, name: 'integ_chat');
  });
}
