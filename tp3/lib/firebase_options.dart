import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "VOTRE_API_KEY",
      authDomain: "VOTRE_AUTH_DOMAIN",
      projectId: "VOTRE_PROJECT_ID",
      storageBucket: "VOTRE_STORAGE_BUCKET",
      messagingSenderId: "VOTRE_MESSAGING_SENDER_ID",
      appId: "VOTRE_APP_ID",
      measurementId: "VOTRE_MEASUREMENT_ID",
    );
  }
}
