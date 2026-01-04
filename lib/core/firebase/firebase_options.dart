/// Firebase configuration options
/// Generated from google-services.json and GoogleService-Info.plist
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfvUkENmclZGQKp1S7etzbbr0uWLS6NoE',
    appId: '1:149956547132:android:283d2b0eecebec5fba2939',
    messagingSenderId: '149956547132',
    projectId: 'german-med',
    storageBucket: 'german-med.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxcvJAhcG8NW8P64hLmc8f0fv_IrPeHvA',
    appId: '1:149956547132:ios:3fcc0c2d88f9d48cba2939',
    messagingSenderId: '149956547132',
    projectId: 'german-med',
    storageBucket: 'german-med.firebasestorage.app',
    iosClientId: '149956547132-171jjqiqi6fc9l2k1hlqiu1p5kpo47lg.apps.googleusercontent.com',
    iosBundleId: 'app.deutsch.med',
  );
}
