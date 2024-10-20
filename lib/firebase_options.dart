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
    apiKey: 'AIzaSyCsgzXWkhvMVes4gft1QAzTbkxahD_qGsU',
    appId: '1:878560725333:web:f11a49d4e77123e99f07dc',
    messagingSenderId: '878560725333',
    projectId: 'cryptowallet-76389',
    authDomain: 'cryptowallet-76389.firebaseapp.com',
    storageBucket: 'cryptowallet-76389.appspot.com',
    measurementId: 'G-C0GH7M4ZFW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKSSpm3NU4tLoZ6Sqs_Vazdwv9Zcdg6JU',
    appId: '1:878560725333:android:77bfe1d1209035309f07dc',
    messagingSenderId: '878560725333',
    projectId: 'cryptowallet-76389',
    storageBucket: 'cryptowallet-76389.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCD4cMBdD-spNT3lEFKwArQmECjOXRosGQ',
    appId: '1:878560725333:ios:8a2a6fd4b2280a3c9f07dc',
    messagingSenderId: '878560725333',
    projectId: 'cryptowallet-76389',
    storageBucket: 'cryptowallet-76389.appspot.com',
    iosBundleId: 'com.example.test',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCD4cMBdD-spNT3lEFKwArQmECjOXRosGQ',
    appId: '1:878560725333:ios:8a2a6fd4b2280a3c9f07dc',
    messagingSenderId: '878560725333',
    projectId: 'cryptowallet-76389',
    storageBucket: 'cryptowallet-76389.appspot.com',
    iosBundleId: 'com.example.test',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCsgzXWkhvMVes4gft1QAzTbkxahD_qGsU',
    appId: '1:878560725333:web:4e2b1c5e1f657bb59f07dc',
    messagingSenderId: '878560725333',
    projectId: 'cryptowallet-76389',
    authDomain: 'cryptowallet-76389.firebaseapp.com',
    storageBucket: 'cryptowallet-76389.appspot.com',
    measurementId: 'G-38BLGTLYMY',
  );
}
