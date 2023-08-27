import 'package:equatable/equatable.dart';

import '../../student/models/student.dart';
import '../../ustaz/models/ustaz_model.dart';
import '../class_model.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminScreenLoading extends AdminState {}

class StudentOperationProgress extends AdminState {}

class ImageOperationProgress extends AdminState {}


class AdminUstazLoading extends AdminState {}

class AdminClassLoading extends AdminState {}

class LogOutSuccessState extends AdminState {
  @override
  List<Object> get props => [];
}

class LogOutFailureState extends AdminState {
  final Object error;

  const LogOutFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class LogOutLoadingState extends AdminState {
  @override
  List<Object> get props => [];
}


class IntialStudentsState extends AdminState {
  final List<Student> students;

  const IntialStudentsState({required this.students});

  @override
  List<Object> get props => [students];
}

class ImageAddSuccess extends AdminState {
  final String avatar;

  const ImageAddSuccess({required this.avatar});

  @override
  List<Object> get props => [avatar];
}

class IntialClassessState extends AdminState {
  final List<Classs> classes;

  const IntialClassessState({required this.classes});

  @override
  List<Object> get props => [classes];
}
class IntialUstazsState extends AdminState {
  final List<Ustaz> ustazs;

  const IntialUstazsState({required this.ustazs});

  @override
  List<Object> get props => [ustazs];
}

class InitialFailureState extends AdminState {
  final String message;

  const InitialFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class ImageAddFailure extends AdminState {
  final String message;

  const ImageAddFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class InitialClassFailureState extends AdminState {
  final String message;

  const InitialClassFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class InitialUstazFailureState extends AdminState {
  final String message;

  const InitialUstazFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class StudentOperationSuccess extends AdminState {
  final List<Student> students;

  const StudentOperationSuccess({required this.students});

  @override
  List<Object> get props => [students];
}

class UstazDeleteOperationSuccess extends AdminState {
  final List<Ustaz> ustazs;

  const UstazDeleteOperationSuccess({required this.ustazs});

  @override
  List<Object> get props => [ustazs];
}
class ClassDeleteOperationSuccess extends AdminState {
  final List<Classs> classes;

  const ClassDeleteOperationSuccess({required this.classes});

  @override
  List<Object> get props => [classes];
}
class StudentUpdateOperationSuccess extends AdminState {
  final List<Student> students;

  const StudentUpdateOperationSuccess({required this.students});

  @override
  List<Object> get props => [students];
}

class UstazUpdateOperationSuccess extends AdminState {
  final List<Ustaz> ustazs;

  const UstazUpdateOperationSuccess({required this.ustazs});

  @override
  List<Object> get props => [ustazs];
}

class classUpdateOperationSuccess extends AdminState {
  final List<Classs> classes;

  const classUpdateOperationSuccess({required this.classes});

  @override
  List<Object> get props => [classes];
}

class StudentAddOperationSuccess extends AdminState {
  final List<Student> students;

  const StudentAddOperationSuccess({required this.students});

  @override
  List<Object> get props => [students];
}

class ClassAddOperationSuccess extends AdminState {
  final List<Classs> classes;

  const ClassAddOperationSuccess({required this.classes});

  @override
  List<Object> get props => [classes];
}

class UstazAddOperationSuccess extends AdminState {
  final List<Ustaz> ustazs;

  const UstazAddOperationSuccess({required this.ustazs});

  @override
  List<Object> get props => [ustazs];
}

class StudentOperationFailure extends AdminState {
  final String message;

  const StudentOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ClassOperationFailure extends AdminState {
  final String message;

  const ClassOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class UstazOperationFailure extends AdminState {
  final String message;

  const UstazOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}



