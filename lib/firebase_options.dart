// Firebase configuration for ARank India Master.
// This configuration targets the existing ARank India Firebase project.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase is not configured for this platform in this project.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6192b8tzVzb_O1Kdm3QrIcfiRyIRHDL8',
    appId: '1:128130227904:web:95bb04a5af01b68cedd725',
    messagingSenderId: '128130227904',
    projectId: 'arank-india',
    authDomain: 'arank-india.firebaseapp.com',
    storageBucket: 'arank-india.firebasestorage.app',
    measurementId: 'G-RZWFDWCNWW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO_isDqt7gPA_iC6Qbr3Xvcz6iKMtDVi4',
    appId: '1:128130227904:android:0909eb956d68971fedd725',
    messagingSenderId: '128130227904',
    projectId: 'arank-india',
    storageBucket: 'arank-india.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCBd1yaciONvVrjiI_0gQXzpnZvw7-QD8',
    appId: '1:128130227904:ios:08af1c4b59bbb9deedd725',
    messagingSenderId: '128130227904',
    projectId: 'arank-india',
    storageBucket: 'arank-india.firebasestorage.app',
    iosBundleId: 'com.arankindia.arankIndia',
  );
}
