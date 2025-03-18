import 'package:health_care_app/model/notebook.dart';

import '../model/appointment.dart';
import '../model/notification.dart';

abstract class Repository {
  // appointment
  Future<Appointment> addAppointment(Appointment appointment);
  Future<List<Appointment>> getAppointments();
  Future<void> deleteAppointment(String id);

  // notification
  Future<Notification> addNotification(Notification notification);
  Future<List<Notification>> getNotifications();
  Future<void> deleteNotification(String id);

  // notebook
  Future<Notebook>addNote(Notebook note);
  Future<List<Notebook>> getNotes();
  Future<void> deleteNote (String id);



  String getUserId();
}
