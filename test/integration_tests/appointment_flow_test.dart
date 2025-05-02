import 'package:flutter_test/flutter_test.dart';
import '../utils/benchmark_helper.dart';
import 'utils/common_actions.dart';

void main() {
  testWidgets('appointment CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();

      await login(tester);
      await tester.tap(find.text('Appointments'));
      await tester.pumpAndSettle();

      await addAppointment(tester);
      await editAppointment(tester);
      await deleteAppointment(tester);
    }, name: 'integ_appointment_crud');
  });
}
