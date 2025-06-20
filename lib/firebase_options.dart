// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDk_R3e58IMT3rcE5Wb_sc6Pb1SZmkwo6Y',
    appId: '1:956659056108:web:3f0b78b35e308a781254c9',
    messagingSenderId: '956659056108',
    projectId: 'skinmatch-8d88b',
    authDomain: 'skinmatch-8d88b.firebaseapp.com',
    databaseURL: 'https://skinmatch-8d88b-default-rtdb.firebaseio.com',
    storageBucket: 'skinmatch-8d88b.firebasestorage.app',
    measurementId: 'G-KYWN0RWRBL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJWJFvyge_1XAYI2ErbswC0gd18WfnzgQ',
    appId: '1:956659056108:android:c506b90a0f20f2a01254c9',
    messagingSenderId: '956659056108',
    projectId: 'skinmatch-8d88b',
    databaseURL: 'https://skinmatch-8d88b-default-rtdb.firebaseio.com',
    storageBucket: 'skinmatch-8d88b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgfHqnZs5YQVZDeBE2Cl9CUeYxJGzI2ks',
    appId: '1:956659056108:ios:f2ea5307352f48d11254c9',
    messagingSenderId: '956659056108',
    projectId: 'skinmatch-8d88b',
    databaseURL: 'https://skinmatch-8d88b-default-rtdb.firebaseio.com',
    storageBucket: 'skinmatch-8d88b.firebasestorage.app',
    iosBundleId: 'com.example.skinMatch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgfHqnZs5YQVZDeBE2Cl9CUeYxJGzI2ks',
    appId: '1:956659056108:ios:f2ea5307352f48d11254c9',
    messagingSenderId: '956659056108',
    projectId: 'skinmatch-8d88b',
    databaseURL: 'https://skinmatch-8d88b-default-rtdb.firebaseio.com',
    storageBucket: 'skinmatch-8d88b.firebasestorage.app',
    iosBundleId: 'com.example.skinMatch',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDk_R3e58IMT3rcE5Wb_sc6Pb1SZmkwo6Y',
    appId: '1:956659056108:web:c612a77c0af32fa91254c9',
    messagingSenderId: '956659056108',
    projectId: 'skinmatch-8d88b',
    authDomain: 'skinmatch-8d88b.firebaseapp.com',
    databaseURL: 'https://skinmatch-8d88b-default-rtdb.firebaseio.com',
    storageBucket: 'skinmatch-8d88b.firebasestorage.app',
    measurementId: 'G-JNWNHKEZD3',
  );

}