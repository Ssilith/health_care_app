import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';

class AppointmentService {
  final Repository _repository;

  AppointmentService() : _repository = RepositoryImpl();
  AppointmentService.withRepository(this._repository);

  Future<List<Appointment>> getAllAppointments() async {
    return await _repository.getAppointments();
  }

  Future<Appointment> addAppointment(Appointment note) async {
    return await _repository.addAppointment(note);
  }

  Future<Appointment> editAppointment(Appointment note) async {
    return await _repository.editAppointment(note);
  }

  Future<void> deleteAppointment(String noteId) async {
    await _repository.deleteAppointment(noteId);
  }
}
