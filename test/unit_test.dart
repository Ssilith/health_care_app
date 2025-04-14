import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/model/building.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/model/notebook.dart';
import 'package:health_care_app/services/appointment_service.dart';
import 'package:health_care_app/services/auth_service.dart';
import 'package:health_care_app/services/geo_service.dart';
import 'package:health_care_app/services/ice_service.dart';
import 'package:health_care_app/services/notebook_service.dart';
import 'package:health_care_app/services/chat_service.dart';
import 'package:health_care_app/services/insert_pdf_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mocks.mocks.dart';

class FakeFilePickerUtils extends Fake implements FilePickerUtils {
  @override
  Future<FilePickerResult?> pickSingleFile() async {
    // Create a dummy PDF document using Syncfusion.
    final PdfDocument document = PdfDocument();
    // Add a blank page.
    document.pages.add();
    // document.save() returns a List<int>; convert it to Uint8List.
    final Uint8List pdfBytes = Uint8List.fromList(await document.save());
    document.dispose();
    return FilePickerResult([
      PlatformFile(name: "dummy.pdf", size: pdfBytes.length, bytes: pdfBytes),
    ]);
  }
}

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

class FakeNotebookService extends Fake implements NotebookService {
  @override
  Future<Notebook> addNote(Notebook note) async => note;
}

class FakeChatService extends Fake implements ChatService {
  @override
  Future<String> fetchChatGPTResponse(String prompt) async {
    return "Fake GPT response";
  }

  @override
  Future<String> sendPrompt(String prompt) async {
    return "Fake prompt reply";
  }
}

/// For GeoService tests.
class FakeGeoService extends GeoService {
  FakeGeoService({super.client});
  @override
  Future<String> getApiKey() async => "fake_geo_key";
}

void main() {
  // ---------- Authentication and Firebase CRUD tests ----------
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  late MockRepository mockRepository;
  late IceService iceService;
  late NotebookService notebookService;
  late AppointmentService appointmentService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
    mockRepository = MockRepository();
    iceService = IceService.withRepository(mockRepository);
    notebookService = NotebookService.withRepository(mockRepository);
    appointmentService = AppointmentService.withRepository(mockRepository);
  });

  group('AuthService Tests', () {
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
        ).thenAnswer((_) => Future.value(userCredential));

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
        ).thenAnswer((_) => Future.value(userCredential));

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
        ).thenAnswer((_) => Future.value());

        await authService.resetPassword('test@example.com');

        verify(
          mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'),
        ).called(1);
      },
    );
  });

  group('Firebase CRUD Tests', () {
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

  group('ChatService Tests', () {
    test('fetchChatGPTResponse returns expected content', () async {
      final fakeResponse = {
        "choices": [
          {
            "message": {"content": "Expected response"},
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final chatService = ChatService(client: client);
      final response = await chatService.fetchChatGPTResponse("dummy prompt");
      expect(response, equals("Expected response"));
    });

    test('sendPrompt returns expected content', () async {
      final fakeResponse = {
        "choices": [
          {
            "message": {"content": "Prompt reply"},
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final chatService = ChatService(client: client);
      final response = await chatService.sendPrompt("Hello");
      expect(response, equals("Prompt reply"));
    });
  });

  group('InsertPdfService Tests', () {
    late FakeFilePickerUtils fakeFilePickerUtils;
    setUp(() {
      fakeFilePickerUtils = FakeFilePickerUtils();
    });

    test(
      'handlePdfAndCreateNote returns a Notebook with expected content',
      () async {
        final fakeChatService = FakeChatService();
        final fakeNotebookService = FakeNotebookService();
        final insertPdfService = InsertPdfService(
          notebookService: fakeNotebookService,
          chatService: fakeChatService,
          filePickerUtils: fakeFilePickerUtils,
        );

        final Notebook? note = await insertPdfService.handlePdfAndCreateNote();

        expect(note, isNotNull);
        expect(note!.noteTitle, equals("Chat GPT Note"));
        expect(note.noteContent, equals("Fake GPT response"));
      },
    );
  });

  group('GeoService Tests', () {
    test('findNearestPharmacy returns a list of Buildings', () async {
      final fakeResponse = {
        "features": [
          {
            "geometry": {
              "coordinates": [100.0, 50.0],
            },
            "properties": {
              "name": "Pharmacy One",
              "address_line2": "123 Pharmacy St",
              "datasource": {
                "raw": {"phone": "111-222", "website": "http://pharmacy.one"},
              },
            },
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final geoService = FakeGeoService(client: client);

      final locationData = LocationData.fromMap({
        "latitude": 50.0,
        "longitude": 100.0,
      });

      final buildings = await geoService.findNearestPharmacy(locationData);

      expect(buildings, isA<List<Building>>());
      expect(buildings.length, equals(1));
      expect(buildings.first.name, equals("Pharmacy One"));
      expect(buildings.first.address, equals("123 Pharmacy St"));
      expect(buildings.first.phone, equals("111-222"));
      expect(buildings.first.website, equals("http://pharmacy.one"));
    });

    test('findNearestHospital returns a list of Buildings', () async {
      final fakeResponse = {
        "features": [
          {
            "geometry": {
              "coordinates": [101.0, 51.0],
            },
            "properties": {
              "name": "Hospital One",
              "address_line2": "456 Hospital Rd",
              "datasource": {
                "raw": {"phone": "333-444", "website": "http://hospital.one"},
              },
            },
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final geoService = FakeGeoService(client: client);

      final locationData = LocationData.fromMap({
        "latitude": 51.0,
        "longitude": 101.0,
      });
      final buildings = await geoService.findNearestHospital(locationData);

      expect(buildings, isA<List<Building>>());
      expect(buildings.length, equals(1));
      expect(buildings.first.name, equals("Hospital One"));
      expect(buildings.first.address, equals("456 Hospital Rd"));
      expect(buildings.first.phone, equals("333-444"));
      expect(buildings.first.website, equals("http://hospital.one"));
    });
  });
}
