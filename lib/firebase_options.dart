// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions belum dikonfigurasi untuk iOS.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions belum dikonfigurasi untuk macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions belum dikonfigurasi untuk Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions belum dikonfigurasi untuk Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions tidak didukung untuk platform ini.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeC3AffFWh3pvvRBnIMAAeLKGJ2ifP32Q',
    appId: '1:863419494341:android:3055ec44055460d84725ac',
    messagingSenderId: '863419494341',
    projectId: 'airishop',
    storageBucket: 'airishop.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZE0Rfzhr2OGsXzCpUXoMqaKzXAghiCGQ',
    appId: '1:863419494341:web:ba0b3acdedb5c1654725ac',
    messagingSenderId: '863419494341',
    projectId: 'airishop',
    storageBucket: 'airishop.firebasestorage.app',
    authDomain: 'airishop.firebaseapp.com',
    measurementId: 'G-C26WDHLDVH',
  );
}
