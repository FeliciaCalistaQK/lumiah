import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart';

// Import screens Anda
import 'package:skin_match/screens/login_screen.dart';
import 'package:skin_match/screens/main_screen.dart'; // Ini adalah Home Screen Anda
import 'package:skin_match/screens/register_screen.dart';
import 'package:skin_match/screens/home_screen.dart'; // Tambahkan import untuk HomeScreen jika berbeda dari MainScreen
import 'package:skin_match/screens/detail_screen.dart'; // Import DetailScreen


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Tidak perlu lagi mengambil isLoggedIn dari SharedPreferences di sini,
  // karena StreamBuilder akan menanganinya secara real-time.
  runApp(const SkinMatchApp());
}

class SkinMatchApp extends StatelessWidget {
  const SkinMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkinMatch',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'DeliciousHandrawn',
      ),
      // Gunakan StreamBuilder untuk mendengarkan perubahan status otentikasi
      home: StreamBuilder<User?>( // User? bisa null jika tidak ada yang login
        stream: FirebaseAuth.instance.authStateChanges(), // Stream dari Firebase Auth
        builder: (context, snapshot) {
          // Menampilkan loading screen atau splash screen saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika ada pengguna yang login (snapshot.hasData dan snapshot.data tidak null)
          if (snapshot.hasData && snapshot.data != null) {
            // Pengguna sudah login, arahkan ke MainScreen (Home Screen Anda)
            return const MainScreen(); // Pastikan ini adalah halaman utama setelah login
          } else {
            // Tidak ada pengguna yang login, arahkan ke LoginScreen
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(), // Tetap definisikan untuk navigasi manual jika diperlukan
        '/register': (context) => const RegisterScreen(),

        // Jika HomeScreen dan MainScreen adalah hal yang sama, cukup gunakan salah satunya.
        // Jika HomeScreen adalah bagian dari MainScreen (misal, tab di bottom nav), maka '/home' bisa dihapus
        // atau diarahkan ke MainScreen.
        '/actual_home_content': (context) => const HomeScreen(), // Contoh jika HomeScreen adalah konten sebenarnya

        '/detail': (context) => const DetailScreen(),

      },
    );
  }
}