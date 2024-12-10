import 'package:flutter/material.dart';

class QuizzPage extends StatefulWidget {
  const QuizzPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  final List<Question> _questions = [
    Question(
      questionText: "La capitale de la France est Paris.",
      isCorrect: true,
    ),
    Question(
      questionText: "La Tour Eiffel a été construite en 1900.",
      isCorrect: false,
    ),
    Question(
      questionText: "La France est surnommée l'Hexagone à cause de sa forme géographique.",
      isCorrect: true,
    ),
    Question(
      questionText: "Le français est la langue officielle de 15 pays dans le monde.",
      isCorrect: false,
    ),
    Question(
      questionText: "La Marseillaise est l'hymne national de la France.",
      isCorrect: true,
    ),
    Question(
      questionText: "Le Mont Saint-Michel se trouve en Normandie.",
      isCorrect: true,
    ),
    Question(
      questionText: "La France n'a jamais remporté de Coupe du Monde de football.",
      isCorrect: false,
    ),
    Question(
      questionText: "La région Provence-Alpes-Côte d'Azur est connue pour ses plages.",
      isCorrect: true,
    ),
    Question(
      questionText: "L'Arc de Triomphe se trouve à Marseille.",
      isCorrect: false,
    ),
    Question(
      questionText: "Le fleuve la Seine traverse Lyon.",
      isCorrect: false,
    ),
  ];


  int _currentQuestionIndex = 0;
  int _score = 0;

  void _checkAnswer(bool userChoice) {
    if (_questions[_currentQuestionIndex].isCorrect == userChoice) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _currentQuestionIndex++; // Moves to the result card
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 24.0)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _currentQuestionIndex < _questions.length
              ? _buildQuizBody()
              : _buildResultCard(),
        ),
      ),
    );
  }

  Widget _buildQuizBody() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 20.0),
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add the image inside the card
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/quizzBC.jpeg', // Replace with your image asset
              width: 300,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20), // Space below the image

          // Display the question text
          Text(
            _questions[_currentQuestionIndex].questionText,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Space below the question

          // Add the buttons for "Vrai" and "Faux"
          ElevatedButton(
            onPressed: () => _checkAnswer(true),
            child: const Text("Vrai"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _checkAnswer(false),
            child: const Text("Faux"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    double scorePercentage = (_score / _questions.length) * 100;
    String gifPath;
    Color backgroundColor;

    if (scorePercentage > 70) {
      gifPath = 'assets/images/congrats.gif';
      backgroundColor = Colors.green[400]!;
    } else if (scorePercentage >= 50) {
      gifPath = 'assets/images/goodjob.gif';
      backgroundColor = Colors.yellow[400]!;
    } else {
      gifPath = 'assets/images/tryagain.gif';
      backgroundColor = Colors.red[400]!;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.9;
        double gifSize = cardWidth * 0.6;

        return Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Résultats du Quizz",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Votre score : $_score/${_questions.length}",
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: gifSize,
                height: gifSize,
                child: Image.asset(
                  gifPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _restartQuiz,
                child: const Text("Recommencer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Question {
  String questionText;
  bool isCorrect;

  Question({required this.questionText, required this.isCorrect});
}