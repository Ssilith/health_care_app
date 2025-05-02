import 'package:flutter_test/flutter_test.dart';
import 'utils/common_actions.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('ICE CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();
      await addIceInfo(tester);
      await editIceInfo(tester);
      await deleteIceInfo(tester);
    }, name: 'integ_ice_crud');
  });
}
