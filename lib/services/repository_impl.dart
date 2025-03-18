import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/model/notification.dart';
import 'package:health_care_app/services/firebase_paths.dart';
import 'package:health_care_app/services/repository.dart';

import '../model/notebook.dart';

class RepositoryImpl implements Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Appointment> addAppointment(Appointment appointment) async {
    DocumentReference documentReference = await _firestore
        .collection(FirebasePaths.appointments)
        .add(appointment.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();

    return Appointment.fromSnaphot(documentSnapshot);
  }

  @override
  Future<List<Appointment>> getAppointments() async {
    var querySnapshot = await _firestore
        .collection(FirebasePaths.appointments)
        .where("userId", isEqualTo: getUserId())
        .get();
    return querySnapshot.docs
        .map((doc) => Appointment.fromSnaphot(doc))
        .toList();
  }

  @override
  Future<void> deleteAppointment(String id) async {
    var questionDocRef =
        _firestore.collection(FirebasePaths.appointments).doc(id);
    return await questionDocRef.delete();
  }

  @override
  Future<Notification> addNotification(Notification notification) async {
    DocumentReference documentReference = await _firestore
        .collection(FirebasePaths.notifications)
        .add(notification.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();

    return Notification.fromSnaphot(documentSnapshot);
  }

  @override
  Future<List<Notification>> getNotifications() async {
    var querySnapshot = await _firestore
        .collection(FirebasePaths.notifications)
        .where("userId", isEqualTo: getUserId())
        .get();
    return querySnapshot.docs
        .map((doc) => Notification.fromSnaphot(doc))
        .toList();
  }

  @override
  Future<void> deleteNotification(String id) async {
    var questionDocRef =
        _firestore.collection(FirebasePaths.notifications).doc(id);
    return await questionDocRef.delete();
  }

  @override
  Future<Notebook> addNote(Notebook note) async {
    DocumentReference documentReference = await _firestore
        .collection(FirebasePaths.notes)
        .add(note.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();

    return Notebook.fromSnaphot(documentSnapshot);
  }

  @override
  Future<List<Notebook>> getNotes() async {
    var querySnapshot = await _firestore
        .collection(FirebasePaths.notes)
        .where("userId", isEqualTo: getUserId())
        .get();
    return querySnapshot.docs.map((doc) => Notebook.fromSnaphot(doc)).toList();
  }

  @override
  Future<void> deleteNote(String id) async {
    var questionDocRef =
        _firestore.collection(FirebasePaths.notes).doc(id);
    return await questionDocRef.delete();
  }

  @override
  String getUserId() {
    return _firebaseAuth.currentUser?.uid ??
        (throw Exception("Null Firebase User"));
  }
}
