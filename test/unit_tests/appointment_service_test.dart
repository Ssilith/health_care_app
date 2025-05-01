import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/services/appointment_service.dart';
import 'package:mockito/mockito.dart';
import '../utils/benchmark_helper.dart';
import 'utils/mocks.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late AppointmentService appointmentService;

  setUp(() {
    mockRepository = MockRepository();
    appointmentService = AppointmentService.withRepository(mockRepository);
  });

  group('AppointmentService Tests', () {
    test('getAllAppointments returns list of Appointment', () async {
      final appointments = [
        Appointment(
          id: '1',
          userId: 'user1',
          date: DateTime.parse('2022-01-01'),
          doctorType: 'General',
          doctorName: 'Dr. Smith',
          location: 'Clinic A',
          purpose: 'Checkup',
        ),
        Appointment(
          id: '2',
          userId: 'user1',
          date: DateTime.parse('2022-02-01'),
          doctorType: 'Dentist',
          doctorName: 'Dr. Brown',
          location: 'Clinic B',
          purpose: 'Cleaning',
        ),
      ];

      when(
        mockRepository.getAppointments(),
      ).thenAnswer((_) => Future.value(appointments));

      await runPerf(() async {
        await appointmentService.getAllAppointments();
      }, name: 'appointment_getAllAppointments');

      reset(mockRepository);
      when(
        mockRepository.getAppointments(),
      ).thenAnswer((_) => Future.value(appointments));

      final result = await appointmentService.getAllAppointments();

      expect(result, appointments);
      verify(mockRepository.getAppointments()).called(1);
    });

    test('addAppointment returns added Appointment', () async {
      final newAppointment = Appointment(
        id: '3',
        userId: 'user1',
        date: DateTime.parse('2022-03-01'),
        doctorType: 'Cardiologist',
        doctorName: 'Dr. Heart',
        location: 'Clinic C',
        purpose: 'Consultation',
      );

      when(
        mockRepository.addAppointment(newAppointment),
      ).thenAnswer((_) => Future.value(newAppointment));

      await runPerf(() async {
        await appointmentService.addAppointment(newAppointment);
      }, name: 'appointment_addAppointment');

      reset(mockRepository);
      when(
        mockRepository.addAppointment(newAppointment),
      ).thenAnswer((_) => Future.value(newAppointment));

      final result = await appointmentService.addAppointment(newAppointment);

      expect(result, newAppointment);
      verify(mockRepository.addAppointment(newAppointment)).called(1);
    });

    test('editAppointment returns edited Appointment', () async {
      final updatedAppointment = Appointment(
        id: '1',
        userId: 'user1',
        date: DateTime.parse('2022-01-01'),
        doctorType: 'General',
        doctorName: 'Dr. Smith Updated',
        location: 'Clinic A',
        purpose: 'Checkup Updated',
      );

      when(
        mockRepository.editAppointment(updatedAppointment),
      ).thenAnswer((_) => Future.value(updatedAppointment));

      await runPerf(() async {
        await appointmentService.editAppointment(updatedAppointment);
      }, name: 'appointment_editAppointment');

      reset(mockRepository);
      when(
        mockRepository.editAppointment(updatedAppointment),
      ).thenAnswer((_) => Future.value(updatedAppointment));

      final result = await appointmentService.editAppointment(
        updatedAppointment,
      );

      expect(result, updatedAppointment);
      verify(mockRepository.editAppointment(updatedAppointment)).called(1);
    });

    test('deleteAppointment completes successfully', () async {
      when(
        mockRepository.deleteAppointment('1'),
      ).thenAnswer((_) => Future.value());

      await runPerf(() async {
        await appointmentService.deleteAppointment('1');
      }, name: 'appointment_deleteAppointment');

      reset(mockRepository);
      when(
        mockRepository.deleteAppointment('1'),
      ).thenAnswer((_) => Future.value());

      await appointmentService.deleteAppointment('1');

      verify(mockRepository.deleteAppointment('1')).called(1);
    });
  });
}
