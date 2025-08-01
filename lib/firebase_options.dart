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
    apiKey: 'AIzaSyBtbnu4AuikDILDR7ztwumV_FvAF7lHtKs',
    appId: '1:524135962701:web:7f0941431bde89b9fc2404',
    messagingSenderId: '524135962701',
    projectId: 'boilerplate-bc548',
    authDomain: 'boilerplate-bc548.firebaseapp.com',
    storageBucket: 'boilerplate-bc548.firebasestorage.app',
    measurementId: 'G-0RHQVLXDXQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqBXBYFraxoZ8J2KoEO-7PxCc4FvPB2hk',
    appId: '1:524135962701:android:6bdffab26fa11f40fc2404',
    messagingSenderId: '524135962701',
    projectId: 'boilerplate-bc548',
    storageBucket: 'boilerplate-bc548.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcTO9Msd7oFDbxicU7cKSckgXaOE7fAN0',
    appId: '1:524135962701:ios:2871af06dc4634f2fc2404',
    messagingSenderId: '524135962701',
    projectId: 'boilerplate-bc548',
    storageBucket: 'boilerplate-bc548.firebasestorage.app',
    androidClientId: '524135962701-jpuebrk0d5h37gtg5426740af93g42v7.apps.googleusercontent.com',
    iosClientId: '524135962701-485mi7r3tvm9586u4pv86os9o3dn7i85.apps.googleusercontent.com',
    iosBundleId: 'com.example.boilerplateTemplate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcTO9Msd7oFDbxicU7cKSckgXaOE7fAN0',
    appId: '1:524135962701:ios:2871af06dc4634f2fc2404',
    messagingSenderId: '524135962701',
    projectId: 'boilerplate-bc548',
    storageBucket: 'boilerplate-bc548.firebasestorage.app',
    androidClientId: '524135962701-jpuebrk0d5h37gtg5426740af93g42v7.apps.googleusercontent.com',
    iosClientId: '524135962701-485mi7r3tvm9586u4pv86os9o3dn7i85.apps.googleusercontent.com',
    iosBundleId: 'com.example.boilerplateTemplate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBtbnu4AuikDILDR7ztwumV_FvAF7lHtKs',
    appId: '1:524135962701:web:1709999965852fc6fc2404',
    messagingSenderId: '524135962701',
    projectId: 'boilerplate-bc548',
    authDomain: 'boilerplate-bc548.firebaseapp.com',
    storageBucket: 'boilerplate-bc548.firebasestorage.app',
    measurementId: 'G-YGRH21FTVN',
  );

}