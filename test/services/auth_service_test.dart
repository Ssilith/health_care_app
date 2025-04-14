import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import '../utils/benchmark_helper.dart';
import '../utils/fakes_and_mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
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

        await runBenchmark(() async {
          await authService.signUp('test@example.com', 'password', 'password');
        }, testName: 'auth_signUp');

        reset(mockFirebaseAuth);
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

        await runBenchmark(() async {
          await authService.signIn('test@example.com', 'password');
        }, testName: 'auth_signIn');

        reset(mockFirebaseAuth);
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

        await runBenchmark(() async {
          await authService.resetPassword('test@example.com');
        }, testName: 'auth_resetPassword');

        reset(mockFirebaseAuth);
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
}
