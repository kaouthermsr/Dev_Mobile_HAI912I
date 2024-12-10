import 'package:flutter/material.dart';
import '../../Data/providers/firebase_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseProvider firebaseProvider = FirebaseProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,  // Couleur de fond
        child: Center(
          child: Text(
            'Bienvenue sur l\'écran de connexion!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,  // Texte en noir pour la lisibilité
            ),
          ),
        ),
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Connexion')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TextField(
  //             controller: emailController,
  //             decoration: InputDecoration(
  //               labelText: 'Email',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           SizedBox(height: 16),
  //           TextField(
  //             controller: passwordController,
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               labelText: 'Mot de passe',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () async {
  //               try {
  //                 await firebaseProvider.signIn(
  //                   emailController.text,
  //                   passwordController.text,
  //                 );
  //                 Navigator.pushNamed(context, '/quiz');
  //               } catch (e) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text("Erreur de connexion")),
  //                 );
  //               }
  //             },
  //             child: Text("Se connecter"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/signup');
  //             },
  //             child: Text("Créer un compte"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
