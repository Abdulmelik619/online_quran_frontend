import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/admin/class_model.dart';
import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../student/models/student.dart';
import '../../student/repository/student_repository.dart';
import '../../ustaz/ustaz_repository/ustaz_repository.dart';
import '../db.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminClassBloc extends Bloc<AdminEvent, AdminState> {
  final StudentRepository studentRepository;
  final UstazRepository ustazRepository;

  AdminClassBloc(
      {required this.studentRepository, required this.ustazRepository})
      : super(AdminClassLoading()) {
    on<InitclassesEvent>((event, emit) async {
      emit(AdminClassLoading());
      try {
        var classProfiles = await ustazRepository.fetchallclasses();

        List<Classs> classes = [];

        for (var classProfile in classProfiles) {
          Classs classs = Classs(
            id: classProfile["_id"],
            className: classProfile["className"],
            dateCreated: classProfile['dateCreated'],
            assignedTeacherId: classProfile["assignedTeacherId"],
          );
          classes.add(classs);
        }
        emit(IntialClassessState(classes: classes));
      } catch (error) {
        emit(InitialClassFailureState(
            message: 'Failed to load user profile: $error'));
      }
    });

    on<AddClassButton>(((event, emit) async {
      try {
        emit(StudentOperationProgress());
        await studentRepository.addClass(
            event.className, event.dateCreated, event.assignedTeacherId);

        var classProfiles = await ustazRepository.fetchallclasses();

        List<Classs> classes = [];

        for (var classProfile in classProfiles) {
          Classs classs = Classs(
            id: classProfile["_id"],
            className: classProfile["className"],
            dateCreated: classProfile['dateCreated'],
            assignedTeacherId: classProfile["assignedTeacherId"],
          );
          classes.add(classs);
        }
        emit(ClassAddOperationSuccess(classes: classes));
      } catch (error) {
        print(error.toString());
        emit(ClassOperationFailure(message: error.toString()));
      }
    }));

    on<UpdateclassButton>(((event, emit) async {
      try {
        emit(StudentOperationProgress());
        print(event.classs.id);
        final classProfile =
            await ustazRepository.updateClassProfile(event.classs);
        var classProfiles = await ustazRepository.fetchallclasses();

        List<Classs> classes = [];

        for (var classProfile in classProfiles) {
          Classs classs = Classs(
            id: classProfile["_id"],
            className: classProfile["className"],
            dateCreated: classProfile['dateCreated'],
            assignedTeacherId: classProfile["assignedTeacherId"],
          );
          classes.add(classs);
        }

        emit(classUpdateOperationSuccess(classes: classes));
      } catch (error) {
        print(error.toString());
        emit(ClassOperationFailure(message: error.toString()));
      }
    }));

    on<DeleteClassButtonPressed>(((event, emit) async {
      try {
        print("Sertual");

        await studentRepository.deleteclass(event.id);
        var classProfiles = await ustazRepository.fetchallclasses();

        List<Classs> classes = [];

        for (var classProfile in classProfiles) {
          Classs classs = Classs(
            id: classProfile["_id"],
            className: classProfile["className"],
            dateCreated: classProfile['dateCreated'],
            assignedTeacherId: classProfile["assignedTeacherId"],
          );
          classes.add(classs);
        }

        emit(ClassDeleteOperationSuccess(classes: classes));
      } catch (error) {
        print(error.toString());
        emit(ClassOperationFailure(message: error.toString()));
      }
    }));

   on<AdminLogOutButtonPressed>(
      (event, emit) async {
        // if (state is LogOutLoading) return;
        emit(LogOutLoadingState());
        // Future.delayed(Duration(seconds: delay));
        try {
          // LoginCredentials loginCredentials = LoginCredentials();
          await studentRepository.logout(event.email);

          AdminLoginCredentials adminloginCredentials = AdminLoginCredentials();
          adminloginCredentials.deleteLoginCredentials();

          emit(LogOutSuccessState());
          // emit( LoginLoadingState());
        } catch (error) {
          emit(LogOutFailureState(error: error));
        }
      },
    );
  }
}
