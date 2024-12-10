import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Question>> fetchQuestions() async {
    final querySnapshot = await _firestore.collection('questions').get();
    return querySnapshot.docs
        .map((doc) => Question.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> addQuestion(Question question) async {
    await _firestore.collection('questions').add(question.toFirestore());
  }
}
