

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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.fuchsia:
        // TODO: Handle this case.
      case TargetPlatform.linux:
        // TODO: Handle this case.
      case TargetPlatform.windows:
        // TODO: Handle this case.
      case TargetPlatform.macOS:
        // TODO: Handle this case.
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'xxxxxxxxxxxxxxxxxxx',
    appId: 'xxxxxxxxxxxxxxxxxxx',
    messagingSenderId: 'xxxxxxxxxxxxxxxxxxx',
    projectId: 'xxxxxxxxxxxxxxxxxxx',
    authDomain: 'xxxxxxxxxxxxxxxxxxx',
    databaseURL: 'xxxxxxxxxxxxxxxxxxx',
    storageBucket: 'xxxxxxxxxxxxxxxxxxx',
   measurementId: 'xxxxxxxxxxxxxxxxxxx',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdqAdf001aB1rquq3sBV567aBpeE2AZnY',
    appId: '1:132460292077:android:99702cd5aa1c62c611a9e4',
    messagingSenderId: '132460292077',
    projectId: 'virtuozy-f9690',
    databaseURL: 'xxxxxxxxxxxxxxxxxxx',
    storageBucket: 'virtuozy-f9690.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzYgQ3JMr4aPq8T0uEz1wUcsTxEdnkUso',
    appId: '1:132460292077:ios:d70968d3542aa15611a9e4',
    messagingSenderId: '132460292077',
    projectId: 'virtuozy-f9690',
   // databaseURL: 'xxxxxxxxxxxxxxxxxxx',
   // storageBucket: 'virtuozy-f9690.firebasestorage.app',
    //androidClientId: 'xxxxxxxxxxxxxxxxxxx',
   // iosClientId: '1:132460292077:ios:d70968d3542aa15611a9e4',
   // iosBundleId: 'ru.virtuozy',
  );


}