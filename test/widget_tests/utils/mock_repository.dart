// Create in test/mocks/mock_repository.dart
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/repository.dart';

class MockRepository implements Repository {
  @override
  Future<Appointment> addAppointment(Appointment appointment) async {
    return appointment;
  }

  @override
  Future<Appointment> editAppointment(Appointment appointment) async {
    return appointment;
  }

  @override
  Future<List<Appointment>> getAppointments() async {
    return [];
  }

  @override
  Future<void> deleteAppointment(String id) async {
    return;
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
  Future<List<Notebook>> getNotes() async {
    return [];
  }

  @override
  Future<void> deleteNote(String id) async {
    return;
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
  Future<List<IceInfo>> getIceInfos() async {
    return [];
  }

  @override
  Future<void> deleteIceInfo(String id) async {
    return;
  }

  @override
  String getUserId() {
    return "test-user-id";
  }
}
