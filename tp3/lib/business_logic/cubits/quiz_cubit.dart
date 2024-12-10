import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/models/question.dart';
import '../../Data/repositories/quiz_repository.dart';

abstract class QuizState {}
class QuizInitial extends QuizState {}
class QuizLoaded extends QuizState {
  final List<Question> questions;
  QuizLoaded(this.questions);
}

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository quizRepository;

  QuizCubit(this.quizRepository) : super(QuizInitial());

  Future<void> loadQuestions() async {
    final questions = await quizRepository.fetchQuestions();
    emit(QuizLoaded(questions));
  }
}
