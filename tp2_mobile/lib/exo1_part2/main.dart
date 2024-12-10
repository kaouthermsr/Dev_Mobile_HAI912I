import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_cubit.dart';
import 'package:tp2_mobile/exo1_part2/quizz_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(), // Fournit le QuizCubit
      child: MaterialApp(
        title: 'Application Quizz',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const QuizzPage(),
      ),
    );
  }
}
