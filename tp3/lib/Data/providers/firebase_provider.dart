import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';


class FirebaseProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Méthode de création d'un utilisateur
  Future<User?> signUp(String email, String password) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Méthode de connexion d'un utilisateur
  Future<User?> signIn(String email, String password) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Récupération des questions du quiz
  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final querySnapshot = await firestore.collection('questions').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Téléchargement de fichiers vers Firebase Storage
  Future<String> uploadFile(String path, String fileName, Uint8List fileData) async {
    final ref = storage.ref().child('$path/$fileName');
    await ref.putData(fileData);
    return await ref.getDownloadURL();
  }
}
