import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'QuizModel.dart';
import 'main.dart';

class QuizzPage extends StatelessWidget {
  const QuizzPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quizz Flutter",
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Consumer<QuizModel>(
        builder: (context, quizModel, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: quizModel.quizFinished
                  ? _buildResultCard(quizModel, context) // Result Card
                  : _buildQuestionCard(quizModel), // Question Card
            ),
          );
        },
      ),
    );
  }


// Card for displaying questions
  Widget _buildQuestionCard(QuizModel quizModel) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
          Image.asset(
            quizModel.currentImageUrl, // Dynamic local image path
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            quizModel.currentQuestion,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Buttons in a Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => quizModel.checkAnswer(true),
                child: const Text("Vrai"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                ),
              ),
              ElevatedButton(
                onPressed: () => quizModel.checkAnswer(false),
                child: const Text("Faux"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Card for displaying results
  Widget _buildResultCard(QuizModel quizModel, BuildContext context) {
    String gifPath;
    Color backgroundColor;

    // Calculate the score percentage
    double scorePercentage = (quizModel.score / quizModel.totalQuestions) * 100;

    // Assign GIF and background based on score percentage
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
                "Votre score : ${quizModel.score}/${quizModel.totalQuestions}",
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
                onPressed: () {
                  quizModel.restartQuiz();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false, // Remove all previous routes
                  );
                },
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
