import 'package:flutter_test/flutter_test.dart';
import 'utils/common_actions.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('location permission + nearest hospitals', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();
      await allowLocationPermission(tester);
      await tester.pumpAndSettle();
    }, name: 'integ_location_permission');
  });
}
