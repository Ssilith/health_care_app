import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserCredential> signUp(
    String email,
    String password,
    String repeatPassword,
  ) async {
    if (password != repeatPassword) {
      throw Exception("The passwords are not identical");
    }
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
