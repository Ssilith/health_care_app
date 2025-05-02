import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/main_appointments.dart';
import 'package:health_care_app/widgets/action_container.dart';
import '../utils/benchmark_helper.dart';
import 'utils/common_actions.dart';

void main() {
  testWidgets('appointment CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();

      await login(tester);

      await tester.pumpAndSettle(Duration(seconds: 2));

      final actions = find.byType(ActionContainer);
      if (actions.evaluate().isNotEmpty) {
        bool found = false;
        for (var i = 0; i < actions.evaluate().length; i++) {
          final actionWidget = actions.at(i);
          final actionWidgetText = find.descendant(
            of: actionWidget,
            matching: find.byType(Text),
          );

          if (actionWidgetText.evaluate().isNotEmpty) {
            final textWidgets = actionWidgetText.evaluate();
            for (var textElement in textWidgets) {
              final Text text = textElement.widget as Text;
              final String textData = text.data ?? '';

              if (textData.toLowerCase().contains('appointment')) {
                await tester.tap(actionWidget);
                found = true;
                break;
              }
            }
          }

          if (found) break;
        }

        if (!found) {
          final calendarIcon = find.byIcon(Icons.calendar_month);
          if (calendarIcon.evaluate().isNotEmpty) {
            await tester.tap(calendarIcon.first);
            found = true;
          } else {
            final appointmentsWidget = find.byType(MainAppointments);
            if (appointmentsWidget.evaluate().isNotEmpty) {
              found = true;
            } else if (actions.evaluate().isNotEmpty) {
              await tester.tap(actions.first);
            }
          }
        }
      }

      await tester.pumpAndSettle();

      await addAppointment(tester);
      await editAppointment(tester);
      await deleteAppointment(tester);
    }, name: 'integ_appointment_crud');
  });
}
