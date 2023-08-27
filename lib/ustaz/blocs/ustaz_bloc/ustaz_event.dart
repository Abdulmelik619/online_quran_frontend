import 'package:equatable/equatable.dart';

import '../../../student/models/login_model.dart';
import '../../../student/models/student.dart';
import '../../models/ustaz_signup_model.dart';

abstract class UstazEvent extends Equatable {
  const UstazEvent();
}

class UstazRigisterPressed extends UstazEvent {
  final UstazSignUpModel ustazsignUpModel;

  const UstazRigisterPressed({required this.ustazsignUpModel});

  @override
  List<Object?> get props => [ustazsignUpModel];
}

class UstazProfileLoadEvent extends UstazEvent {
  final String email;

  const UstazProfileLoadEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class EvaluateButtonPressed extends UstazEvent {
  final String classId;
  const EvaluateButtonPressed({required this.classId});
  @override
  List<Object?> get props => [classId];
}

class GoBack extends UstazEvent {
  const GoBack();
  @override
  List<Object?> get props => [];
}
class UstazLogOutButtonPressed extends UstazEvent {
  final String email;

  const UstazLogOutButtonPressed({required this.email});

  @override
  List<Object?> get props => [email];
}


class OnSaveEvent extends UstazEvent {
  final Student student;
  final int date;

  const OnSaveEvent({required this.student, required this.date, });
  @override
  List<Object?> get props => [student, date,];
}

class OnUndoEvent extends UstazEvent {
  final Student student;
  final int date;

  const OnUndoEvent({required this.student, required this.date, });
  @override
  List<Object?> get props => [student, date,];
}

class NewDayEvent extends UstazEvent {
  final List<Student> students;

  const NewDayEvent({required this.students, });
  @override
  List<Object?> get props => [students ];
}
