import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/auth/login_page_template.dart';
import 'package:mockito/mockito.dart';
import 'package:health_care_app/services/auth_service.dart';
import '../utils/benchmark_helper.dart';
import 'utils/mocks.mocks.dart';

void main() {
  testWidgets('auth_flow', (tester) async {
    final mockAuth = MockFirebaseAuth();

    AuthService.overrideInstanceForTesting(mockAuth);

    when(
      mockAuth.createUserWithEmailAndPassword(
        email: 'user@test.com',
        password: '123456',
      ),
    ).thenAnswer((_) async => MockUserCredential());

    when(
      mockAuth.signInWithEmailAndPassword(
        email: 'user@test.com',
        password: '123456',
      ),
    ).thenAnswer((_) async => MockUserCredential());

    when(mockAuth.signOut()).thenAnswer((_) async => {});

    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: LoginPageTemplate()));
      await tester.pumpAndSettle();
    }, name: 'auth_flow');
  });
}
