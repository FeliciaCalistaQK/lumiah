import 'package:flutter/material.dart';
import 'package:skin_match/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_match/screens/main_screen.dart';
import 'package:skin_match/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(SkinMatchApp(
    isLoggedIn: isLoggedIn,
  ));
  

}

class SkinMatchApp extends StatelessWidget {
  final bool isLoggedIn;
  const SkinMatchApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'SkinMatch',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Warna tema aplikasi
        fontFamily: 'DeliciousHandrawn', // Font default
      ),
      home: isLoggedIn ? const MainScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/register': (context) => const RegisterScreen(),
        
      },
    );
  }
}
