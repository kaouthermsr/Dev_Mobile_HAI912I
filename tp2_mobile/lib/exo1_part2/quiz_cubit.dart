
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// QuizState model to manage the state
class QuizState {
  final int currentQuestionIndex;
  final int score;
  final bool quizFinished;

  QuizState({
    required this.currentQuestionIndex,
    required this.score,
    required this.quizFinished,
  });

  QuizState copyWith({
    int? currentQuestionIndex,
    int? score,
    bool? quizFinished,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      quizFinished: quizFinished ?? this.quizFinished,
    );
  }
}

// QuizCubit for state management
class QuizCubit extends Cubit<QuizState> {
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
      "question": "Le français est la langue officielle de 15 pays dans le monde.",
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
      "question": "La région Provence-Alpes-Côte d'Azur est connue pour ses plages.",
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

  QuizCubit()
      : super(QuizState(
    currentQuestionIndex: 0,
    score: 0,
    quizFinished: false,
  ));

  // Getter for the current question text and image
  String get currentQuestion =>
      _questions[state.currentQuestionIndex]["question"] as String;

  String get currentImageUrl =>
      _questions[state.currentQuestionIndex]["imageUrl"] as String;

  int get totalQuestions => _questions.length;

  // Feedback for the result
  Map<String, dynamic> getResultFeedback() {
    if (state.score == totalQuestions) {
      return {
        "gifPath": "assets/images/congrats.gif",
        "backgroundColor": Colors.green[100],
      };
    } else if (state.score > totalQuestions / 2) {
      return {
        "gifPath": "assets/images/goodjob.gif",
        "backgroundColor": Colors.yellow[50],
      };
    } else {
      return {
        "gifPath": "assets/images/tryagain.gif",
        "backgroundColor": Colors.red[100],
      };
    }
  }

  // Checks the user's answer
  void checkAnswer(bool userAnswer) {
    if (!state.quizFinished) {
      final isCorrect =
          _questions[state.currentQuestionIndex]["isCorrect"] == userAnswer;

      if (isCorrect) {
        emit(state.copyWith(score: state.score + 1));
      }

      if (state.currentQuestionIndex == totalQuestions - 1) {
        emit(state.copyWith(quizFinished: true));
      } else {
        emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
      }
    }
  }

  // Resets the quiz
  void restartQuiz() {
    emit(QuizState(
      currentQuestionIndex: 0,
      score: 0,
      quizFinished: false,
    ));
  }
}