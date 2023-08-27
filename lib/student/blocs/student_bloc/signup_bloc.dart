import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_event.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_state.dart';
import 'package:online_quran_frontend/student/repository/student_repository.dart';

class SignUpBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  SignUpBloc({required this.studentRepository}) : super(SignUpLoading()) {
    on<SignUpButtonPressed>(((event, emit) async {
      if (state is SignUpOperationLoading) return;
      emit(SignUpOperationLoading());
      try {
        await studentRepository.signup(event.signUpModel);
        emit(SignUpOperationSuccess());
      } catch (error) {
        print(error.toString());
        emit(SignUpFailureState(error: error));
      }
    }));
  }
}
