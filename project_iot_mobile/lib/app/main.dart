import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../core/firebase/firebase_options.dart';
import '../features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Use the generated Firebase options
    );
    print('Firebase initialized successfully!');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const ESP32ControlApp());
}

class ESP32ControlApp extends StatelessWidget {
  const ESP32ControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
