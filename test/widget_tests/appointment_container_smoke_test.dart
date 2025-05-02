import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/appointment_container.dart';
import 'package:health_care_app/model/appointment.dart';
import '../utils/benchmark_helper.dart';
import 'utils/mock_services.dart';

void main() {
  testWidgets('AppointmentContainer builds and shows data', (tester) async {
    final appointment = Appointment(
      date: DateTime(2025, 1, 1, 9, 30),
      doctorType: 'Dentist',
      doctorName: 'Dr Brown',
      location: 'Clinic B',
    );

    await runPerf(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentContainer(
            appointment: appointment,
            onDelete: (_) {},
            onEdit: () {},
            // Pass the mock service
            appointmentService: MockAppointmentService(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Dentist'), findsOneWidget);
      expect(find.text('Dr Brown'), findsOneWidget);
    }, name: 'widget_appointment_smoke');
  });
}
