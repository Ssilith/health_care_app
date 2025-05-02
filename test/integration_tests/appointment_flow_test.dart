import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/main_appointments.dart';
import 'package:health_care_app/services/repository_impl.dart';

import '../utils/benchmark_helper.dart';
import 'utils/hint_text_finder.dart';
import 'utils/mock_repository.dart';

void main() {
  setUpAll(() {
    RepositoryImpl.inject(MockRepository() as RepositoryImpl);
  });

  testWidgets('appointment_crud', (tester) async {
    await runPerf(() async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(home: MainAppointments()));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        await tester.enterText(find.byHintText('Doctor Type'), 'Dentist');
        await tester.enterText(find.byHintText('Doctor Name'), 'Dr Brown');
        await tester.enterText(find.byHintText('Location'), 'Clinic A');

        await tester.enterText(find.byHintText('Date'), '2025-01-01 09:30 AM');

        await tester.ensureVisible(find.text('SUBMIT'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('SUBMIT'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('mainSwitch')));
        await tester.pumpAndSettle();
        expect(find.text('Dentist'), findsOneWidget);

        await tester.drag(find.text('Dentist'), const Offset(300, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byHintText('Doctor Type'), 'Physio');

        await tester.ensureVisible(find.text('SUBMIT'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('SUBMIT'));
        await tester.pumpAndSettle();

        expect(find.text('Physio'), findsOneWidget);

        await tester.drag(find.text('Physio'), const Offset(300, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.ensureVisible(find.text('Confirm'));
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(find.text('Physio'), findsNothing);
      });
    }, name: 'appointment_crud');
  });
}
