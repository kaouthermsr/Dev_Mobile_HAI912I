import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
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
