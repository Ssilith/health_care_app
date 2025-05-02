import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/services/firebase_paths.dart';
import 'package:health_care_app/services/repository.dart';

import '../model/notebook.dart';

class RepositoryImpl implements Repository {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static RepositoryImpl? _testStub;
  static void inject(RepositoryImpl stub) => _testStub = stub;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RepositoryImpl._(this._firestore, this._firebaseAuth);

  factory RepositoryImpl() {
    if (_testStub != null) return _testStub!;
    return RepositoryImpl._(FirebaseFirestore.instance, FirebaseAuth.instance);
  }

  @override
  Future<Appointment> addAppointment(Appointment appointment) async {
    DocumentReference documentReference = await _firestore
        .collection(FirebasePaths.appointments)
        .add(appointment.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();

    return Appointment.fromSnapshot(documentSnapshot);
  }

  @override
  Future<Appointment> editAppointment(Appointment appointment) async {
    DocumentReference documentReference = _firestore
        .collection(FirebasePaths.appointments)
        .doc(appointment.id!);
    await documentReference.update(appointment.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> updatedSnapshot = await documentReference.get();
    return Appointment.fromSnapshot(updatedSnapshot);
  }

  @override
  Future<List<Appointment>> getAppointments() async {
    var querySnapshot =
        await _firestore
            .collection(FirebasePaths.appointments)
            .where("userId", isEqualTo: getUserId())
            .get();
    return querySnapshot.docs
        .map((doc) => Appointment.fromSnapshot(doc))
        .toList();
  }

  @override
  Future<void> deleteAppointment(String id) async {
    var questionDocRef = _firestore
        .collection(FirebasePaths.appointments)
        .doc(id);
    return await questionDocRef.delete();
  }

  @override
  Future<Notebook> addNote(Notebook note) async {
    DocumentReference documentReference = await _firestore
        .collection(FirebasePaths.notes)
        .add(note.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();

    return Notebook.fromSnapshot(documentSnapshot);
  }

  @override
  Future<Notebook> editNote(Notebook note) async {
    DocumentReference documentReference = _firestore
        .collection(FirebasePaths.notes)
        .doc(note.id!);
    await documentReference.update(note.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> updatedSnapshot = await documentReference.get();
    return Notebook.fromSnapshot(updatedSnapshot);
  }

  @override
  Future<List<Notebook>> getNotes() async {
    var querySnapshot =
        await _firestore
            .collection(FirebasePaths.notes)
            .where("userId", isEqualTo: getUserId())
            .get();
    return querySnapshot.docs.map((doc) => Notebook.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> deleteNote(String id) async {
    var questionDocRef = _firestore.collection(FirebasePaths.notes).doc(id);
    return await questionDocRef.delete();
  }

  @override
  Future<IceInfo> addIceInfo(IceInfo info) async {
    DocumentReference documentReference = await _firestore
        .collection(FirebasePaths.iceInfo)
        .add(info.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> documentSnapshot = await documentReference.get();

    return IceInfo.fromSnapshot(documentSnapshot);
  }

  @override
  Future<IceInfo> editIceInfo(IceInfo info) async {
    DocumentReference documentReference = _firestore
        .collection(FirebasePaths.iceInfo)
        .doc(info.id!);
    await documentReference.update(info.toDTOMap(getUserId()));

    DocumentSnapshot<Object?> updatedSnapshot = await documentReference.get();
    return IceInfo.fromSnapshot(updatedSnapshot);
  }

  @override
  Future<List<IceInfo>> getIceInfos() async {
    var querySnapshot =
        await _firestore
            .collection(FirebasePaths.iceInfo)
            .where("userId", isEqualTo: getUserId())
            .get();
    return querySnapshot.docs.map((doc) => IceInfo.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> deleteIceInfo(String id) async {
    var questionDocRef = _firestore.collection(FirebasePaths.iceInfo).doc(id);
    return await questionDocRef.delete();
  }

  @override
  String getUserId() {
    return _firebaseAuth.currentUser?.uid ??
        (throw Exception("Null Firebase User"));
  }
}
