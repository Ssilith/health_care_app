import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:health_care_app/services/auth_service.dart';

import 'utils/mocks.mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthService authService;

  const mail = 'user@test.com';
  const pwd = '123456';

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockAuth);
  });

  group('AuthService - signUp', () {
    test('creates user when passwords match', () async {
      final fakeCred = MockUserCredential();
      when(
        mockAuth.createUserWithEmailAndPassword(email: mail, password: pwd),
      ).thenAnswer((_) async => fakeCred);

      final result = await authService.signUp(mail, pwd, pwd);

      expect(result, fakeCred);
      verify(
        mockAuth.createUserWithEmailAndPassword(email: mail, password: pwd),
      ).called(1);
      verifyNoMoreInteractions(mockAuth);
    });

    test('throws when passwords differ', () async {
      expect(
        () => authService.signUp(mail, pwd, 'OTHER'),
        throwsA(isA<Exception>()),
      );
      verifyZeroInteractions(mockAuth);
    });
  });

  group('signIn', () {
    test('delegates to FirebaseAuth', () async {
      final fakeCred = MockUserCredential();
      when(
        mockAuth.signInWithEmailAndPassword(email: mail, password: pwd),
      ).thenAnswer((_) async => fakeCred);

      final result = await authService.signIn(mail, pwd);

      expect(result, fakeCred);
      verify(
        mockAuth.signInWithEmailAndPassword(email: mail, password: pwd),
      ).called(1);
    });
  });

  group('resetPassword', () {
    test('sends reset email', () async {
      when(
        mockAuth.sendPasswordResetEmail(email: mail),
      ).thenAnswer((_) async => {});

      await authService.resetPassword(mail);

      verify(mockAuth.sendPasswordResetEmail(email: mail)).called(1);
    });
  });

  group('signOut', () {
    test('calls FirebaseAuth.signOut()', () async {
      when(mockAuth.signOut()).thenAnswer((_) async => {});

      await authService.signOut();

      verify(mockAuth.signOut()).called(1);
    });
  });

  group('getUser', () {
    test('returns currentUser from injected FirebaseAuth', () {
      final fakeUser = MockUser();
      when(mockAuth.currentUser).thenReturn(fakeUser);
      final user = authService.getUser();
      expect(user, fakeUser);

      verify(mockAuth.currentUser).called(1);
    });
  });
}
