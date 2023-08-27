import 'package:equatable/equatable.dart';
import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../student/models/signup_model.dart';
import '../../student/models/student.dart';
import '../../ustaz/models/ustaz_signup_model.dart';
import '../class_model.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
}

class InitstudentsEvent extends AdminEvent {
  @override
  List<Object?> get props => [];
}

class AddImage extends AdminEvent {
  @override
  List<Object?> get props => [];
}

class InitclassesEvent extends AdminEvent {
  @override
  List<Object?> get props => [];
}

class InitustazEvent extends AdminEvent {
  @override
  List<Object?> get props => [];
}

class AddStudentButton extends AdminEvent {
  final SignUpModel signUpModel;

  const AddStudentButton({required this.signUpModel});

  @override
  List<Object?> get props => [signUpModel];
}

class AddUstazButton extends AdminEvent {
  final UstazSignUpModel ustazsignUpModel;

  const AddUstazButton({required this.ustazsignUpModel});

  @override
  List<Object?> get props => [ustazsignUpModel];
}

class AddClassButton extends AdminEvent {
  final String className;
  final String dateCreated;
  final String assignedTeacherId;

  const AddClassButton({required this.className, required this.dateCreated,required  this.assignedTeacherId,} );

  @override
  List<Object?> get props => [className, dateCreated, assignedTeacherId ];
}

class UpdateStudentButton extends AdminEvent {
  final Student student;

  const UpdateStudentButton({required this.student});

  @override
  List<Object?> get props => [student];
}

class UpdateclassButton extends AdminEvent {
  final Classs classs;

  const UpdateclassButton({required this.classs});

  @override
  List<Object?> get props => [classs];
}

class UpdateUstazButton extends AdminEvent {
  final Ustaz ustaz;

  const UpdateUstazButton({required this.ustaz});

  @override
  List<Object?> get props => [ustaz];
}

class DeleteButtonPressed extends AdminEvent {
  final String email;

  const DeleteButtonPressed({required this.email});

  @override
  List<Object?> get props => [email];
}

class DeleteUstazButtonPressed extends AdminEvent {
  final String email;

  const DeleteUstazButtonPressed({required this.email});

  @override
  List<Object?> get props => [email];
}

class DeleteClassButtonPressed extends AdminEvent {
  final String id;

  const DeleteClassButtonPressed({required this.id});

  @override
  List<Object?> get props => [id];
}

class AdminLogOutButtonPressed extends AdminEvent {
  final String email;

  const AdminLogOutButtonPressed({required this.email});

  @override
  List<Object?> get props => [email];
}
