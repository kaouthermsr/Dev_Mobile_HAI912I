import 'package:flutter/material.dart';
import 'package:tp1/exo1/ProfileHomePage.dart';

void main() {
  runApp(const MyApp());
}

//Widget racine de l'application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carte de Profil',
      theme: ThemeData( //Data Relative au théme choisi
        primarySwatch: Colors.lightBlue,
      ),
      home: const ProfileHomePage(),//widget de la page d'acceuil
    );
  }
}
