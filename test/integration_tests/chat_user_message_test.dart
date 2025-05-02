import 'package:flutter_test/flutter_test.dart';
import 'utils/common_actions.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('chat bot message test', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();
      await sendChatMessageEnhanced(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
    }, name: 'integ_chat');
  });
}
