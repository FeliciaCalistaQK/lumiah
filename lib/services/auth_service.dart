import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan stream perubahan status autentikasi
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Register dengan email dan password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // Anda bisa menambahkan displayName saat registrasi jika diinginkan
      // await user?.updateDisplayName('Nama Pengguna Default');
      return user;
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      print('Error during registration: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during registration: $e');
      return null;
    }
  }

  // Sign in dengan email dan password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print('Error during sign in: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error during sign in: $e');
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }
}