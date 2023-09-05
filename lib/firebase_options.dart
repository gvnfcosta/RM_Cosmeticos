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
        return ios;
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
    apiKey: 'AIzaSyBSycGT_t9EY5cFNCLHbTR8Ep-tZRZH-YY',
    appId: '1:1011727596728:web:325bd8496403b3e30d084d',
    messagingSenderId: '1011727596728',
    projectId: 'rmapp-3284d',
    authDomain: 'rmapp-3284d.firebaseapp.com',
    databaseURL: 'https://rmapp-3284d-default-rtdb.firebaseio.com',
    storageBucket: 'rmapp-3284d.appspot.com',
    measurementId: 'G-K2H40F217Q',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBSycGT_t9EY5cFNCLHbTR8Ep-tZRZH-YY',
    appId: '1:1011727596728:web:325bd8496403b3e30d084d',
    messagingSenderId: '1011727596728',
    projectId: 'rmapp-3284d',
    authDomain: 'rmapp-3284d.firebaseapp.com',
    databaseURL: 'https://rmapp-3284d-default-rtdb.firebaseio.com',
    storageBucket: 'rmapp-3284d.appspot.com',
    measurementId: 'G-K2H40F217Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYdCMMtFnqaOAd0qPr3dL_DUKez-2G9f0',
    appId: '1:1011727596728:android:eec77bb60c2f27480d084d',
    messagingSenderId: '1011727596728',
    projectId: 'rmapp-3284d',
    databaseURL: 'https://rmapp-3284d-default-rtdb.firebaseio.com',
    storageBucket: 'rmapp-3284d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFkkY-drK9emzj_X8sWgC7MpMPHG4Raf4',
    appId: '1:1011727596728:ios:ce9ca6a3d3b385ad0d084d',
    messagingSenderId: '1011727596728',
    projectId: 'rmapp-3284d',
    databaseURL: 'https://rmapp-3284d-default-rtdb.firebaseio.com',
    storageBucket: 'rmapp-3284d.appspot.com',
    iosClientId:
        '1011727596728-fp6vc43lnur85sv7b80otvsg0s3brcdq.apps.googleusercontent.com',
    iosBundleId: 'br.com.rmc',
  );
}