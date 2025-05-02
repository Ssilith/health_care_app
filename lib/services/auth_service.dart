import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;

  static FirebaseAuth? _testOverride;
  static void overrideInstanceForTesting(FirebaseAuth auth) {
    _testOverride = auth;
  }

  AuthService({FirebaseAuth? firebaseAuth})
    : firebaseAuth = firebaseAuth ?? _testOverride ?? FirebaseAuth.instance;

  Future<UserCredential> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  User? getUser() {
    return firebaseAuth.currentUser;
  }
}
