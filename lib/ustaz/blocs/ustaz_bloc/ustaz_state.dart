import 'package:equatable/equatable.dart';

import '../../../student/models/student.dart';
import '../../models/ustaz_model.dart';

abstract class UstazState extends Equatable {
  const UstazState();

  @override
  List<Object> get props => [];
}

class UstazSignUpLoading extends UstazState {}

class SavingState extends UstazState {
  @override
  List<Object> get props => [];
}

class UstazSignUpOperationLoading extends UstazState {}

class UstazSignUpOperationSuccess extends UstazState {
  @override
  List<Object> get props => [];
}

class UstazSignUpFailureState extends UstazState {
  final Object error;

  const UstazSignUpFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class UstazProfileLoadingState extends UstazState {}

class UstazProfileLoadSuccess extends UstazState {
  const UstazProfileLoadSuccess();

  @override
  List<Object> get props => [];
}

class UstazProfileUpdateSuccess extends UstazState {
  final Ustaz ustaz;

  const UstazProfileUpdateSuccess({required this.ustaz});

  @override
  List<Object> get props => [ustaz];
}

class UstazProfileError extends UstazState {
  final String message;

  const UstazProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class EvaluationLoadingState extends UstazState {}

class EvaluationSuccessState extends UstazState {
  final List<Student> students;

  const EvaluationSuccessState({
    required this.students,
  });

  @override
  List<Object> get props => [students];
}

class EvaluationFetchFailure extends UstazState {
  final String error;

  const EvaluationFetchFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SaveSuccessState extends UstazState {
  final List<Student> students;
  const SaveSuccessState(this.students);
  @override
  List<Object> get props => [students];
}

class SaveAbscentSuccessState extends UstazState {
  const SaveAbscentSuccessState();
  @override
  List<Object> get props => [];
}

class SaveFailureState extends UstazState {
  final String error;

  const SaveFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class UndoSuccessState extends UstazState {
  final List<Student> students;
  const UndoSuccessState(this.students);
  @override
  List<Object> get props => [students];
}

class NewDayState extends UstazState {
  final List<Student> students;
  const NewDayState(this.students);
  @override
  List<Object> get props => [students];
}
class LogOutSuccessState extends UstazState {
  @override
  List<Object> get props => [];
}

class UndoFailureState extends UstazState {
  final String error;

  const UndoFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class LogOutFailureState extends UstazState {
  final Object error;

  const LogOutFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
