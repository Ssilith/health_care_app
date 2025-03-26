import 'package:cloud_firestore/cloud_firestore.dart';

class IceInfo {
  final String? id;
  final String? userId;
  final String fullName;
  final String birthDate;
  final String gender;
  final String? bloodType;
  final String? allergies;
  final String? medicalConditions;
  final String? medications;
  final String? emergencyContactName;
  final String? emergencyContactNumber;
  final String? relation;
  final String? insuranceProvider;
  final String? insuranceNumber;

  IceInfo({
    this.id,
    this.userId,
    required this.fullName,
    required this.birthDate,
    required this.gender,
    this.bloodType,
    this.allergies,
    this.medicalConditions,
    this.medications,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.relation,
    this.insuranceProvider,
    this.insuranceNumber,
  });

  factory IceInfo.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return IceInfo(
      id: snapshot.id,
      userId: data['userId'] as String?,
      fullName: data['fullName'] as String,
      birthDate: data['birthDate'] as String,
      gender: data['gender'] as String,
      bloodType: data['bloodType'] as String?,
      allergies: data['allergies'] as String?,
      medicalConditions: data['medicalConditions'] as String?,
      medications: data['medications'] as String?,
      emergencyContactName: data['emergencyContactName'] as String?,
      emergencyContactNumber: data['emergencyContactNumber'] as String?,
      relation: data['relation'] as String?,
      insuranceProvider: data['insuranceProvider'] as String?,
      insuranceNumber: data['insuranceNumber'] as String?,
    );
  }

  Map<String, dynamic> toDTOMap(String userId) {
    return {
      'userId': userId,
      'fullName': fullName,
      'birthDate': birthDate,
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'emergencyContactName': emergencyContactName,
      'emergencyContactNumber': emergencyContactNumber,
      'relation': relation,
      'insuranceProvider': insuranceProvider,
      'insuranceNumber': insuranceNumber,
    };
  }
}
