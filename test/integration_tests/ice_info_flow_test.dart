import 'package:flutter_test/flutter_test.dart';

import '../utils/benchmark_helper.dart';
import 'utils/common_actions.dart';

void main() {
  testWidgets('ICE CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();

      await login(tester);
      await tester.tap(find.text('In case of emergency'));
      await tester.pumpAndSettle();

      await addIceInfo(tester);
      await deleteIceInfo(tester);
    }, name: 'integ_ice_crud');
  });
}
