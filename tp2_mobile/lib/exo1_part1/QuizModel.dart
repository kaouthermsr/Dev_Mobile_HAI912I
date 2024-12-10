import 'package:flutter/material.dart';

class QuizModel extends ChangeNotifier {
  // List of questions with text, answers, and image URLs
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "La capitale de la France est Paris.",
      "isCorrect": true,
      "imageUrl": "assets/images/Q1-Paris.jpeg",
    },
    {
      "question": "La Tour Eiffel a été construite en 1900.",
      "isCorrect": false,
      "imageUrl": "assets/images/Q2-tourEiffel.jpeg",
    },
    {
      "question": "La France est surnommée l'Hexagone à cause de sa forme géographique.",
      "isCorrect": true,
      "imageUrl": "assets/images/Q3-franceHEx.jpeg",
    },
    {
      "question": "Le français est la langue officielle de 15 pays dans le monde",
      "isCorrect": false,
      "imageUrl": "assets/images/Q4-frnçais.jpeg",
    },
    {
      "question": "La Marseillaise est l'hymne national de la France.",
      "isCorrect": true,
      "imageUrl": "assets/images/Q5-HymneFrançais.jpeg",
    },
    {
      "question": "Le Mont Saint-Michel se trouve en Normandie.",
      "isCorrect": true,
      "imageUrl": "assets/images/Q6-SaintMichel.jpeg",
    },
    {
      "question": "La France n'a jamais remporté de Coupe du Monde de football.",
      "isCorrect": false,
      "imageUrl": "assets/images/Q7-CoupeFoot.jpeg",
    },
    {
      "question": "La région Provence-Alpes-Côte d'Azur est connue pour ses plages",
      "isCorrect": true,
      "imageUrl": "assets/images/Q8-PlagePaCa.jpeg",
    },
    {
      "question": "L'Arc de Triomphe se trouve à Marseille.",
      "isCorrect": false,
      "imageUrl": "assets/images/Q9-Arc de triomphe.jpeg",
    },
    {
      "question": "Le fleuve la Seine traverse Lyon.",
      "isCorrect": false,
      "imageUrl": "assets/images/Q10-Lyon.jpeg",
    },
  ];

  int _currentQuestionIndex = 0; // Current question index
  int _score = 0; // User's score
  bool _quizFinished = false; // Whether the quiz is finished

  // Getter to access data
  String get currentQuestion =>
      _questions[_currentQuestionIndex]["question"] as String;

  String get currentImageUrl =>
      _questions[_currentQuestionIndex]["imageUrl"] as String;

  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  int get score => _score;
  int get totalQuestions => _questions.length;

  bool get quizFinished => _quizFinished;

  // Check the answer and handle progression
  void checkAnswer(bool userAnswer) {
    if (_quizFinished) return;

    if (_questions[_currentQuestionIndex]["isCorrect"] == userAnswer) {
      _score++;
    }

    if (isLastQuestion) {
      _quizFinished = true; // End the quiz after the last question
    } else {
      _currentQuestionIndex++; // Move to the next question
    }

    notifyListeners(); // Update the UI
  }

  // Reset the quiz
  void restartQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _quizFinished = false;
    notifyListeners();
  }
}
