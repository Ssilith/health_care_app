import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../utils/benchmark_helper.dart';
import '../utils/fakes_and_mocks.dart';
import 'package:health_care_app/services/auth_service.dart';

void main() {
  late MockFirebaseAuth mock;
  late AuthService service;

  setUp(() {
    mock = MockFirebaseAuth();
    service = AuthService(firebaseAuth: mock);
  });

  test('signIn surfaces FirebaseAuthException', () async {
    when(
      mock.signInWithEmailAndPassword(email: 'email', password: 'password'),
    ).thenThrow(Exception('firebase down'));

    // expect(() => service.signIn('e@x.com', 'pw'), throwsA(isA<Exception>()));

    await runPerf(() async {
      expect(() => service.signIn('e@x.com', 'pw'), throwsA(isA<Exception>()));
    }, name: 'auth_signIn_exception');
  });
}
