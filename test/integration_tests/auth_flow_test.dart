import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/auth/login_page_template.dart';
import 'package:health_care_app/main.dart';
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

  testWidgets('user_logout_flow', (tester) async {
    final mockAuth = MockFirebaseAuth();
    final mockUser = MockUser();

    AuthService.overrideInstanceForTesting(mockAuth);
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockAuth.signOut()).thenAnswer((_) async => {});

    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPageTemplate), findsOneWidget);

      verify(mockAuth.signOut()).called(1);
    }, name: 'user_logout_flow');
  });
}
