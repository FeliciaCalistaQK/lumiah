import 'package:flutter/material.dart';
import 'package:skin_match/services/auth_service.dart'; // Import AuthService
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for FirebaseAuthException

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _error = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _error = 'Passwords do not match.';
        });
        return; // Hentikan eksekusi jika password tidak cocok
      }

      setState(() {
        _isLoading = true;
        _error = ''; // Bersihkan error sebelumnya
      });

      try {
        await _auth.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        // Jika registrasi berhasil, StreamBuilder di main.dart akan menangani navigasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully! Redirecting...')),
        );
      } on FirebaseAuthException catch (e) { // <-- Pastikan 'on FirebaseAuthException catch (e)'
        // Tangani error spesifik dari Firebase Auth
        setState(() {
          _isLoading = false;
          switch (e.code) {
            case 'weak-password':
              _error = 'The password provided is too weak.';
              break;
            case 'email-already-in-use':
              _error = 'The account already exists for that email.';
              break;
            case 'invalid-email':
              _error = 'The email address is not valid.';
              break;
            default:
              _error = 'Registration failed: ${e.message}'; // Tampilkan pesan dari Firebase
          }
        });
        print('Firebase Auth Error: ${e.code} - ${e.message}'); // Untuk debugging
      } catch (e) {
        // Tangani error umum lainnya
        setState(() {
          _isLoading = false;
          _error = 'An unexpected error occurred: $e';
        });
        print('General Error: $e'); // Untuk debugging
      }
    }
  }
// class _RegisterScreenState extends State<RegisterScreen> {
//   final AuthService _auth = AuthService(); // Inisialisasi AuthService
//   final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   String _error = ''; // Untuk menampilkan pesan error dari Firebase
//   bool _isLoading = false; // Untuk indikator loading

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       if (_passwordController.text != _confirmPasswordController.text) {
//         setState(() {
//           _error = 'Passwords do not match.';
//         });
//         return;
//       }

//       setState(() {
//         _isLoading = true;
//         _error = ''; // Bersihkan error sebelumnya
//       });

//       try {
//         await _auth.registerWithEmailAndPassword(
//           _emailController.text,
//           _passwordController.text,
//         );
//         // Jika registrasi berhasil, Firebase Auth akan otomatis mendeteksi login
//         // dan StreamBuilder di main.dart akan mengarahkan ke HomeScreen.
//         // Anda bisa tambahkan SnackBar sukses jika ingin.
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Account created successfully! Redirecting...')),
//         );
//         // Tidak perlu Navigator.pushReplacementNamed(context, '/login'); lagi
//         // karena main.dart akan menangani navigasi berdasarkan status auth.
//       } on FirebaseAuthException catch (e) {
//         // Tangani error dari Firebase Auth
//         setState(() {
//           _isLoading = false;
//           switch (e.code) {
//             case 'weak-password':
//               _error = 'The password provided is too weak.';
//               break;
//             case 'email-already-in-use':
//               _error = 'The account already exists for that email.';
//               break;
//             case 'invalid-email':
//               _error = 'The email address is not valid.';
//               break;
//             default:
//               _error = 'Registration failed. ${e.message}';
//           }
//         });
//       } catch (e) {
//         // Tangani error umum
//         setState(() {
//           _isLoading = false;
//           _error = 'An unexpected error occurred: $e';
//         });
//       }
//     }
//   }

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
                      'Welcome, \nCreate your account \nand start glowing!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sign up',
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
                    // TextField untuk Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Email'),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    ),
                    const SizedBox(height: 16),

                    // TextField untuk Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Password must be 6+ characters long' : null,
                    ),
                    const SizedBox(height: 16),

                    // TextField untuk Konfirmasi Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Confirm Password'),
                      obscureText: true,
                      // Validasi tambahan untuk konfirmasi password akan dilakukan di _register()
                      validator: (val) => val!.isEmpty ? 'Confirm your password' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Register
              ElevatedButton(
                onPressed: _isLoading ? null : _register, // Nonaktifkan tombol saat loading
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
                        'Sign up',
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
                    Navigator.pushReplacementNamed(context, '/login'); // Arahkan ke LoginScreen
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Log in",
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