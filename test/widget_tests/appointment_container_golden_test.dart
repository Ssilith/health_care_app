import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/appointments/appointment_container.dart';
import 'utils/golden_helper.dart';
import 'utils/mock_services.dart';

void main() {
  testGoldens('AppointmentContainer – default', (tester) async {
    final appt = Appointment(
      date: DateTime(2025, 1, 1, 9, 30),
      doctorType: 'Dentist',
      doctorName: 'Dr Brown',
      location: 'Clinic B',
    );

    await goldenPerf(
      tester,
      AppointmentContainer(
        appointment: appt,
        onDelete: (_) {},
        onEdit: () {},
        appointmentService: MockAppointmentService(),
      ),
      'appointment_container_default',
      surfaceSize: const Size(360, 120),
    );
  });
}
