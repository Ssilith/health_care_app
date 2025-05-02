import 'package:mockito/mockito.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/model/ice_info.dart';

class MockRepository extends Mock implements Repository {
  @override
  String getUserId() {
    return 'test-user-id';
  }

  @override
  Future<List<Appointment>> getAppointments() async {
    return [
      Appointment(
        id: '1',
        doctorType: 'Dentist',
        doctorName: 'Dr Brown',
        location: 'Clinic A',
        date: DateTime(2025, 1, 1, 9, 30),
      ),
    ];
  }

  @override
  Future<Appointment> addAppointment(Appointment appointment) async {
    return appointment;
  }

  @override
  Future<Appointment> editAppointment(Appointment appointment) async {
    return appointment;
  }

  @override
  Future<void> deleteAppointment(String id) async {}

  @override
  Future<List<Notebook>> getNotes() async {
    return [
      Notebook(
        id: '1',
        noteTitle: 'My note',
        noteContent: 'hello world',
        creationDate: DateTime.now().toIso8601String(),
      ),
    ];
  }

  @override
  Future<Notebook> addNote(Notebook note) async {
    return note;
  }

  @override
  Future<Notebook> editNote(Notebook note) async {
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {}

  @override
  Future<List<IceInfo>> getIceInfos() async {
    return [
      IceInfo(
        id: '1',
        fullName: 'Alice Smith',
        birthDate: DateTime(2000, 1, 1).toIso8601String(),
        gender: 'Female',
      ),
    ];
  }

  @override
  Future<IceInfo> addIceInfo(IceInfo info) async {
    return info;
  }

  @override
  Future<IceInfo> editIceInfo(IceInfo info) async {
    return info;
  }

  @override
  Future<void> deleteIceInfo(String id) async {}
}
