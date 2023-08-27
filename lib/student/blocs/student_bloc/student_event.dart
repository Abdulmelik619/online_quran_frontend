import 'package:equatable/equatable.dart';

import '../../models/login_model.dart';
import '../../models/signup_model.dart';
import '../../models/student.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
}

class SignUpButtonPressed extends StudentEvent {
  final SignUpModel signUpModel;

  const SignUpButtonPressed({required this.signUpModel});

  @override
  List<Object?> get props => [signUpModel];
}

class LoginButtonPressed extends StudentEvent {
  final LoginModel loginModel;

  const LoginButtonPressed({required this.loginModel});

  @override
  List<Object> get props => [loginModel];
}

class LogOutButtonPressed extends StudentEvent {
  final String role;

  const LogOutButtonPressed({required this.role});

  @override
  List<Object?> get props => [role];
}

class AdminLogOutButtonPressed extends StudentEvent {
  final String email;

  const AdminLogOutButtonPressed({required this.email});

  @override
  List<Object?> get props => [email];
}

class StudentProfileLoadEvent extends StudentEvent {
  final String email;

  const StudentProfileLoadEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class Navigate extends StudentEvent {
  final String email;

  const Navigate({required this.email});

  @override
  List<Object?> get props => [email];
}

class StudentAbscentLoadEvent extends StudentEvent {
  final String id;

  const StudentAbscentLoadEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class StudentScoreLoadEvent extends StudentEvent {
  final String id;

  const StudentScoreLoadEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class StudentProfileUpdateEvent extends StudentEvent {
  final Student student;

  const StudentProfileUpdateEvent({required this.student});

  @override
  List<Object?> get props => [student];
}
