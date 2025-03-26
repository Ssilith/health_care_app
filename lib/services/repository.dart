import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/model/notebook.dart';
import '../model/appointment.dart';

abstract class Repository {
  // appointment
  Future<Appointment> addAppointment(Appointment appointment);
  Future<Appointment> editAppointment(Appointment appointment);
  Future<List<Appointment>> getAppointments();
  Future<void> deleteAppointment(String id);

  // notebook
  Future<Notebook> addNote(Notebook note);
  Future<Notebook> editNote(Notebook note);
  Future<List<Notebook>> getNotes();
  Future<void> deleteNote(String id);

  // ice info
  Future<IceInfo> addIceInfo(IceInfo info);
  Future<IceInfo> editIceInfo(IceInfo info);
  Future<List<IceInfo>> getIceInfos();
  Future<void> deleteIceInfo(String id);

  String getUserId();
}
