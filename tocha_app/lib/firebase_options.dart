// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBKcszXvDIR7Tte9bCiosmPbzEtjard8QM',
    appId: '1:22964837164:web:0855f365ae48219f126a89',
    messagingSenderId: '22964837164',
    projectId: 'todo-fapp',
    authDomain: 'todo-fapp.firebaseapp.com',
    storageBucket: 'todo-fapp.appspot.com',
    measurementId: 'G-7KMWY0QGTH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZWw1M6PJUlcIpVYho6NBxiiyo_OpQO-M',
    appId: '1:22964837164:android:2e8ae5a6ecc1e368126a89',
    messagingSenderId: '22964837164',
    projectId: 'todo-fapp',
    storageBucket: 'todo-fapp.appspot.com',
  );
}
