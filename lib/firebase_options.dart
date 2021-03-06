// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDdkkB6JWNnwiwAo4JM7xxysGUzmsW0AM',
    appId: '1:781912164056:android:c855a2b1685d949a9739ad',
    messagingSenderId: '781912164056',
    projectId: 'uqu-map',
    storageBucket: 'uqu-map.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDr1fjUTt54ni5Qh6OqWzUZeaVlItnhfqY',
    appId: '1:781912164056:ios:f0cd3796e9bc53549739ad',
    messagingSenderId: '781912164056',
    projectId: 'uqu-map',
    storageBucket: 'uqu-map.appspot.com',
    iosClientId: '781912164056-gs51ae16e2l7dv4pls4df6k42410ksiu.apps.googleusercontent.com',
    iosBundleId: 'com.uqumap.uquMapApp',
  );
}
