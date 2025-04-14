import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/services/ice_service.dart';
import 'package:mockito/mockito.dart';
import '../utils/mocks.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late IceService iceService;

  setUp(() {
    mockRepository = MockRepository();
    iceService = IceService.withRepository(mockRepository);
  });

  group('IceService Tests', () {
    test('getAllIceInfos returns list of IceInfo', () async {
      final dummyIceInfos = [
        IceInfo(
          id: '1',
          userId: 'user1',
          fullName: 'John Doe',
          birthDate: '1990-01-01',
          gender: 'Male',
          bloodType: 'O+',
          allergies: 'None',
          medicalConditions: 'None',
          medications: 'None',
          emergencyContactName: 'Jane Doe',
          emergencyContactNumber: '1234567890',
          relation: 'Sister',
          insuranceProvider: 'ABC Insurance',
          insuranceNumber: 'INS123',
        ),
        IceInfo(
          id: '2',
          userId: 'user1',
          fullName: 'Jane Smith',
          birthDate: '1992-01-01',
          gender: 'Female',
          bloodType: 'A+',
          allergies: 'Peanuts',
          medicalConditions: 'Asthma',
          medications: 'Inhaler',
          emergencyContactName: 'John Smith',
          emergencyContactNumber: '0987654321',
          relation: 'Brother',
          insuranceProvider: 'XYZ Insurance',
          insuranceNumber: 'INS456',
        ),
      ];

      when(mockRepository.getUserId()).thenReturn("user1");

      when(
        mockRepository.getIceInfos(),
      ).thenAnswer((_) => Future.value(dummyIceInfos));

      final result = await iceService.getAllIceInfos();

      expect(result, dummyIceInfos);
      verify(mockRepository.getIceInfos()).called(1);
    });

    test('addIceInfo returns added IceInfo', () async {
      final newIceInfo = IceInfo(
        id: '3',
        userId: 'user1',
        fullName: 'Alice Brown',
        birthDate: '1985-05-05',
        gender: 'Female',
        bloodType: 'B+',
        allergies: 'None',
        medicalConditions: 'Diabetes',
        medications: 'Insulin',
        emergencyContactName: 'Bob Brown',
        emergencyContactNumber: '1122334455',
        relation: 'Husband',
        insuranceProvider: 'XYZ Insurance',
        insuranceNumber: 'INS789',
      );

      when(
        mockRepository.addIceInfo(newIceInfo),
      ).thenAnswer((_) => Future.value(newIceInfo));

      final result = await iceService.addIceInfo(newIceInfo);

      expect(result, newIceInfo);
      verify(mockRepository.addIceInfo(newIceInfo)).called(1);
    });

    test('editIceInfo returns edited IceInfo', () async {
      final updatedIceInfo = IceInfo(
        id: '1',
        userId: 'user1',
        fullName: 'John Doe Updated',
        birthDate: '1990-01-01',
        gender: 'Male',
        bloodType: 'O+',
        allergies: 'None',
        medicalConditions: 'None',
        medications: 'None',
        emergencyContactName: 'Jane Doe',
        emergencyContactNumber: '1234567890',
        relation: 'Sister',
        insuranceProvider: 'ABC Insurance',
        insuranceNumber: 'INS123',
      );

      when(
        mockRepository.editIceInfo(updatedIceInfo),
      ).thenAnswer((_) => Future.value(updatedIceInfo));

      final result = await iceService.editIceInfo(updatedIceInfo);

      expect(result, updatedIceInfo);
      verify(mockRepository.editIceInfo(updatedIceInfo)).called(1);
    });

    test('deleteIceInfo completes successfully', () async {
      when(mockRepository.deleteIceInfo('1')).thenAnswer((_) => Future.value());

      await iceService.deleteIceInfo('1');

      verify(mockRepository.deleteIceInfo('1')).called(1);
    });
  });
}
