import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/appointment_service.dart';
import 'package:health_care_app/services/auth_service.dart';
import 'package:health_care_app/services/ice_service.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      super.noSuchMethod(
            Invocation.method(#createUserWithEmailAndPassword, [], {
              #email: email,
              #password: password,
            }),
            returnValue: Future<UserCredential>.value(MockUserCredential()),
          )
          as Future<UserCredential>;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      super.noSuchMethod(
            Invocation.method(#signInWithEmailAndPassword, [], {
              #email: email,
              #password: password,
            }),
            returnValue: Future<UserCredential>.value(MockUserCredential()),
          )
          as Future<UserCredential>;

  @override
  Future<void> sendPasswordResetEmail({
    ActionCodeSettings? actionCodeSettings,
    required String email,
  }) =>
      super.noSuchMethod(
            Invocation.method(#sendPasswordResetEmail, [], {
              #actionCodeSettings: actionCodeSettings,
              #email: email,
            }),
            returnValue: Future<void>.value(),
          )
          as Future<void>;
}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  // ---------- Authentication tests ----------
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  late MockRepository mockRepository;
  late NotebookService notebookService;
  late AppointmentService appointmentService;
  late IceService iceService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
    mockRepository = MockRepository();
    notebookService = NotebookService.withRepository(mockRepository);
    appointmentService = AppointmentService.withRepository(mockRepository);
    iceService = IceService.withRepository(mockRepository);
  });

  group('AuthService', () {
    test('signUp throws exception when passwords do not match', () async {
      expect(
        () => authService.signUp('test@example.com', 'password', 'different'),
        throwsException,
      );
    });

    test(
      'signUp calls createUserWithEmailAndPassword with valid inputs',
      () async {
        final userCredential = MockUserCredential();
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).thenAnswer((_) async => userCredential);

        final result = await authService.signUp(
          'test@example.com',
          'password',
          'password',
        );

        expect(result, equals(userCredential));
        verify(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).called(1);
      },
    );

    test(
      'signIn calls signInWithEmailAndPassword and returns user credential',
      () async {
        final userCredential = MockUserCredential();

        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).thenAnswer((_) async => userCredential);

        final result = await authService.signIn('test@example.com', 'password');

        expect(result, equals(userCredential));
        verify(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).called(1);
      },
    );

    test(
      'resetPassword calls sendPasswordResetEmail with provided email',
      () async {
        when(
          mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'),
        ).thenAnswer((_) async {});

        await authService.resetPassword('test@example.com');

        verify(
          mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'),
        ).called(1);
      },
    );
  });

  // ---------- Geo API tests ----------
  // group('Geo API Tests', () {
  //   // Using real or mocked geo service.
  //   final geoService = GeoService();

  //   test('Find nearest hospitals returns a non-empty list', () async {
  //     // Arrange: sample coordinates (for example, San Francisco).
  //     final latitude = 37.7749;
  //     final longitude = -122.4194;

  //     // Act
  //     final hospitals = await geoService.findNearestHospitals(latitude, longitude);

  //     // Assert: expecting a list with at least one hospital.
  //     expect(hospitals, isA<List>(), reason: 'Should return a list of hospitals');
  //     expect(hospitals.length, greaterThan(0));
  //   });

  //   test('Find nearest pharmacies returns a non-empty list', () async {
  //     // Arrange: use the same sample coordinates.
  //     final latitude = 37.7749;
  //     final longitude = -122.4194;

  //     // Act
  //     final pharmacies = await geoService.findNearestPharmacies(latitude, longitude);

  //     // Assert:
  //     expect(pharmacies, isA<List>(), reason: 'Should return a list of pharmacies');
  //     expect(pharmacies.length, greaterThan(0));
  //   });
  // });

  // // ---------- Chat Bot Tests ----------
  // group('Chat Bot Tests', () {
  //   final chatService = ChatService();

  //   test('Chat bot responds with non-empty output for a query', () async {
  //     // Arrange
  //     final inputMessage = 'Hello, how can I get help?';

  //     // Act
  //     final response = await chatService.getResponse(inputMessage);

  //     // Assert: expect a non-empty response.
  //     expect(response, isNotEmpty, reason: 'Chat bot should return a valid response message');
  //     // Optionally, you could check whether the response includes key phrases.
  //   });
  // });

  // // ---------- Firebase CRUD tests for emergencies, appointments, and notebook data ----------
  group('Firebase CRUD Tests', () {
    group('IceService Tests', () {
      test('getAllIceInfos returns list of IceInfo', () async {
        final iceInfos = [
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

        when(
          mockRepository.getIceInfos(),
        ).thenAnswer((_) => Future.value(iceInfos));

        final result = await iceService.getAllIceInfos();

        expect(result, iceInfos);
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
        when(
          mockRepository.deleteIceInfo('1'),
        ).thenAnswer((_) => Future.value());

        await iceService.deleteIceInfo('1');

        verify(mockRepository.deleteIceInfo('1')).called(1);
      });
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

        await appointmentService.deleteAppointment('1');

        verify(mockRepository.deleteAppointment('1')).called(1);
      });
    });

    group('NotebookService Tests', () {
      test('getAllNotes returns list of Notebook', () async {
        final notes = [
          Notebook(
            id: '1',
            userId: 'user1',
            creationDate: '2022-01-01',
            noteTitle: 'Note 1',
            noteContent: 'Content 1',
          ),
          Notebook(
            id: '2',
            userId: 'user1',
            creationDate: '2022-02-01',
            noteTitle: 'Note 2',
            noteContent: 'Content 2',
          ),
        ];

        when(mockRepository.getNotes()).thenAnswer((_) => Future.value(notes));

        final result = await notebookService.getAllNotes();

        expect(result, notes);
        verify(mockRepository.getNotes()).called(1);
      });

      test('addNote returns added Notebook', () async {
        final newNote = Notebook(
          id: '3',
          userId: 'user1',
          creationDate: '2022-03-01',
          noteTitle: 'Note 3',
          noteContent: 'Content 3',
        );

        when(
          mockRepository.addNote(newNote),
        ).thenAnswer((_) => Future.value(newNote));

        final result = await notebookService.addNote(newNote);

        expect(result, newNote);
        verify(mockRepository.addNote(newNote)).called(1);
      });

      test('editNote returns edited Notebook', () async {
        final updatedNote = Notebook(
          id: '1',
          userId: 'user1',
          creationDate: '2022-01-01',
          noteTitle: 'Note 1 Updated',
          noteContent: 'Content 1 Updated',
        );

        when(
          mockRepository.editNote(updatedNote),
        ).thenAnswer((_) => Future.value(updatedNote));

        final result = await notebookService.editNote(updatedNote);

        expect(result, updatedNote);
        verify(mockRepository.editNote(updatedNote)).called(1);
      });

      test('deleteNote completes successfully', () async {
        when(mockRepository.deleteNote('1')).thenAnswer((_) => Future.value());

        await notebookService.deleteNote('1');

        verify(mockRepository.deleteNote('1')).called(1);
      });
    });
  });

  // // ---------- PDF File and ChatGPT PDF summary tests ----------
  // group('PDF Summary Tests', () {
  //   final pdfService = PdfService();

  //   test('Uploading a PDF and generating summary returns valid summary text', () async {
  //     // Arrange: Provide the path or bytes for a sample PDF.
  //     // In a unit test, you might load a test asset or use dummy data.
  //     final pdfFilePath = 'assets/sample.pdf';

  //     // Act: Call the method that sends the PDF to ChatGPT for summarization.
  //     final summary = await pdfService.getPdfSummary(pdfFilePath);

  //     // Assert: Expect that a summary is returned.
  //     expect(summary, isNotEmpty, reason: 'The PDF summary should not be empty');
  //     // Optionally, assert the summary contains expected keywords.
  //   });
  // });
}
