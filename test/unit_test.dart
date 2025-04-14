import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/services/auth_service.dart';
import 'package:mockito/mockito.dart';

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

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
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
  // group('Firebase CRUD Tests', () {
  //   final firestoreService = FirestoreService();

  //   test('Adding new emergency info succeeds', () async {
  //     // Arrange: Prepare sample emergency info.
  //     final emergencyData = {
  //       'title': 'Emergency Test',
  //       'description': 'This is a test emergency.',
  //       'timestamp': DateTime.now().toIso8601String(),
  //     };

  //     // Act
  //     final result = await firestoreService.addEmergencyInfo(emergencyData);

  //     // Assert
  //     expect(result, isTrue, reason: 'Emergency info should be added successfully');
  //   });

  //   test('Editing appointment info updates data correctly', () async {
  //     // Arrange: Assume you have an appointment ID.
  //     final appointmentId = 'appointment123';
  //     final updateData = {
  //       'time': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
  //       'doctor': 'Dr. Smith',
  //     };

  //     // Act
  //     final result = await firestoreService.editAppointmentInfo(appointmentId, updateData);

  //     // Assert
  //     expect(result, isTrue, reason: 'Appointment info should be updated successfully');
  //   });

  //   test('Deleting a notebook entry removes the entry', () async {
  //     // Arrange: Provide a notebook entry ID.
  //     final notebookEntryId = 'entry123';

  //     // Act
  //     final result = await firestoreService.deleteNotebookEntry(notebookEntryId);

  //     // Assert
  //     expect(result, isTrue, reason: 'Notebook entry should be deleted successfully');
  //   });
  // });

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
