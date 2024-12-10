import 'package:flutter/material.dart';
import 'package:tp1/exo1/ProfileDetailPage.dart';

class ProfileHomePage extends StatelessWidget {
  const ProfileHomePage({Key? key}) : super(key: key);

  final List<Map<String, String>> profiles = const [
    {
      "name": " Abderrahim Dehimat",
      "email": "abderrahim.dehimat@example.com",
      "username": "@Abderrahim.D",
      "avatar": "assets/images/avatar1.jpeg",
      "details": "Abderrahim is a software engineer specializing in Mobile development.",
      "address": "123 Flutter Lane, Code City, Devland",
      "phone": "+123 456 7890",
      "birthdate": "July 27, 2000",
      "hobbies": "Coding, Chess, Traveling"
    },
    {
      "name": "Kaouther Mansouri",
      "email": "kaouther.mansouri@example.com",
      "username": "@Kaouther.M",
      "avatar": "assets/images/avatar2.jpeg",
      "details": "Kaouther is a data analyst with experience in AI and ML.",
      "address": "456 Data Street, Analysis Town, Statsland",
      "phone": "+987 654 3210",
      "birthdate": "February 15, 2000",
      "hobbies": "Reading, Hiking, Machine Learning"
    },
    {
      "name": "Sophie Dupont",
      "email": "sophie.dupont@example.com",
      "username": "@Sophie.D",
      "avatar": "assets/images/avatar2.jpeg",
      "details": "Sophie est une designer UX/UI passionnée par la création d'interfaces conviviales.",
      "address": "45 Rue des Créatifs, Paris, France",
      "phone": "+33 6 12 34 56 78",
      "birthdate": "5 mai 1995",
      "hobbies": "Dessin, Photographie, Voyage"
    },
    {
      "name": "Olivier Martin",
      "email": "olivier.martin@example.com",
      "username": "@Olivier.M",
      "avatar": "assets/images/avatar1.jpeg",
      "details": "Olivier est un développeur backend spécialisé dans le développement d'API et la conception de bases de données.",
      "address": "12 Boulevard des Serveurs, Lyon, France",
      "phone": "+33 6 98 76 54 32",
      "birthdate": "12 mars 1998",
      "hobbies": "Jeux vidéo, Programmation, Cinéma"
    },
    {
      "name": "Claire Bernard",
      "email": "claire.bernard@example.com",
      "username": "@Claire.B",
      "avatar": "assets/images/avatar2.jpeg",
      "details": "Claire est une cheffe de projet experte en méthodologies agiles et en gestion d'équipe.",
      "address": "78 Avenue de l'Agilité, Marseille, France",
      "phone": "+33 7 89 65 43 21",
      "birthdate": "30 octobre 1992",
      "hobbies": "Lecture, Organisation d'événements, Randonnée"
    }

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profiles",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 5.0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Stack(
              clipBehavior: Clip.none, // Ensure the avatar is not clipped
              children: [
                _getCard(profile, context),
                Positioned(
                  top: -10, // Correctly positions the avatar
                  left: 0,
                  right: 0,
                  child: _getAvatar(profile['avatar']!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Card containing the profile information
  Container _getCard(Map<String, String> profile, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 50), // Space for the avatar
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40), // Space below avatar
          Text(
            profile['name']!,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            profile['email']!,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetailPage(profile: profile),
                ),
              );
            },
            child: Text(
              profile['username']!,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Avatar displayed above the card
  Widget _getAvatar(String avatarPath) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.deepPurpleAccent,
      child: CircleAvatar(
        radius: 55,
        backgroundImage: AssetImage(avatarPath),
      ),
    );
  }
}
