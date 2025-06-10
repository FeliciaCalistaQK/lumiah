import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tetap gunakan jika Anda masih memerlukan untuk menyimpan 'isLoggedIn'
import 'package:skin_match/services/auth_service.dart'; // Import AuthService
// Hapus import 'package:skin_match/data/user_data.dart';
// Hapus import 'package:skin_match/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService(); // Inisialisasi AuthService
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _error = ''; // Untuk menampilkan pesan error dari Firebase
  bool _isLoading = false; // Untuk indikator loading

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = ''; // Bersihkan error sebelumnya
      });

      try {
        await _auth.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        // Jika login berhasil, Firebase Auth akan otomatis mendeteksi login
        // dan StreamBuilder di main.dart akan mengarahkan ke HomeScreen.

        // Jika Anda masih ingin menyimpan status login di SharedPreferences:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', _emailController.text); // Simpan email yang login
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful! Redirecting...')),
        );
        // Tidak perlu Navigator.pushReplacementNamed(context, '/home'); lagi
        // karena main.dart akan menangani navigasi berdasarkan status auth.
      } on FirebaseAuthException catch (e) {
        // Tangani error dari Firebase Auth
        setState(() {
          _isLoading = false;
          switch (e.code) {
            case 'user-not-found':
            case 'wrong-password':
              _error = 'Invalid email or password.';
              break;
            case 'invalid-email':
              _error = 'The email address is not valid.';
              break;
            default:
              _error = 'Login failed. ${e.message}';
          }
        });
      } catch (e) {
        // Tangani error umum
        setState(() {
          _isLoading = false;
          _error = 'An unexpected error occurred: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Welcome,\nOne step ahead to\nbe glowingg~',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Form( // Wrap TextFields with Form for validation
                key: _formKey,
                child: Column(
                  children: [
                    // Textfield untuk Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Email'),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    ),
                    const SizedBox(height: 16),
                    // Textfield untuk Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Password must be 6+ characters long' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Tombol login
              ElevatedButton(
                onPressed: _isLoading ? null : _login, // Nonaktifkan tombol saat loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),

              const SizedBox(height: 12.0),
              // Menampilkan pesan error dari Firebase
              Text(
                _error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register'); // Arahkan ke RegisterScreen
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: const Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}