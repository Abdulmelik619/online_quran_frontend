import 'package:equatable/equatable.dart';
import 'package:online_quran_frontend/admin/admin_login_details_model.dart';
import 'package:online_quran_frontend/student/models/models.dart';

import '../../../ustaz/models/ustaz_login_details_model.dart';
import '../../models/abscent.dart';
import '../../models/login_details.dart';
import '../../models/score.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

class SignUpLoading extends StudentState {}

class SignUpOperationLoading extends StudentState {}

class SignUpOperationSuccess extends StudentState {
  @override
  List<Object> get props => [];
}

class SignUpFailureState extends StudentState {
  final Object error;

  const SignUpFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginLoadingState extends StudentState {
  @override
  List<Object> get props => [];
}

class LoginOperationLoadingState extends StudentState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends StudentState {
  final LoginDetailsModel loginDetailsModel;

  const LoginSuccessState({required this.loginDetailsModel});

  @override
  List<Object> get props => [loginDetailsModel];
}

class UstazLoginSuccessState extends StudentState {
  final UstazLoginDetailsModel ustazloginDetailsModel;

  const UstazLoginSuccessState({required this.ustazloginDetailsModel});

  @override
  List<Object> get props => [ustazloginDetailsModel];
}
class AdminLoginSuccessState extends StudentState {
  final AdminLoginDetailsModel adminloginDetailsModel;

  const AdminLoginSuccessState({required this.adminloginDetailsModel});

  @override
  List<Object> get props => [adminloginDetailsModel];
}
class LoginFailureState extends StudentState {
  final Object error;

  const LoginFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class LogOutLoadingState extends StudentState {
  @override
  List<Object> get props => [];
}

class LogOutSuccessState extends StudentState {
  @override
  List<Object> get props => [];
}

class LogOutFailureState extends StudentState {
  final Object error;

  const LogOutFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class StudentProfileLoadingState extends StudentState {}

class StudentAbscentLoadingState extends StudentState {}

class StudentScoreLoadingState extends StudentState {}

class StudentProfileLoadSuccess extends StudentState {
  final Student student;

  const StudentProfileLoadSuccess({
    required this.student,
  });

  @override
  List<Object> get props => [student];
}

class StudentAbscentLoadSuccess extends StudentState {
  final List<Abscent> abscents;

  const StudentAbscentLoadSuccess({
    required this.abscents,
  });

  @override
  List<Object> get props => [abscents];
}

class StudentScoreLoadSuccess extends StudentState {
  final List<Score> scores;

  const StudentScoreLoadSuccess({
    required this.scores,
  });

  @override
  List<Object> get props => [scores];
}

class StudentProfileUpdateSuccess extends StudentState {
  final Student student;

  const StudentProfileUpdateSuccess({required this.student});

  @override
  List<Object> get props => [student];
}

class UserProfileError extends StudentState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object> get props => [message];
}
