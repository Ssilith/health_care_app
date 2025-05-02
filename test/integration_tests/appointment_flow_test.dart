import 'package:flutter_test/flutter_test.dart';
import 'utils/common_actions.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('appointment CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();
      await addAppointment(tester);
      await editAppointment(tester);
      await deleteAppointment(tester);
    }, name: 'integ_appointment_crud');
  });
}
