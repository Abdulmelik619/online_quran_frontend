import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/ustaz/blocs/ustaz_bloc/ustaz_event.dart';
import 'package:online_quran_frontend/ustaz/blocs/ustaz_bloc/ustaz_state.dart';
import 'package:online_quran_frontend/ustaz/models/ustaz_login_details_model.dart';
import 'package:online_quran_frontend/ustaz/ustaz_data_provider/ustaz_db.dart';

import '../../../student/models/student.dart';
import '../../ustaz_repository/ustaz_repository.dart';

class UstazBloc extends Bloc<UstazEvent, UstazState> {
  final UstazRepository ustazRepository;

  UstazBloc({required this.ustazRepository})
      : super(UstazProfileLoadSuccess()) {
    on<GoBack>(((event, emit) async {
      emit(UstazProfileLoadSuccess());
    }));

    on<EvaluateButtonPressed>(((event, emit) async {
      // if (state is SignUpOperationLoading) return;
      emit(EvaluationLoadingState());
      try {
        var studentProfiles =
            await ustazRepository.fetchstudents(event.classId);
        print(studentProfiles);

        List<Student> students = [];

        for (var studentProfile in studentProfiles) {
          Student student = Student(
              id: studentProfile["_id"],
              fullName: studentProfile["fullName"],
              email: studentProfile['email'],
              country: studentProfile["country"],
              sex: studentProfile["sex"],
              kirat_type: studentProfile["kirat_type"],
              hash: studentProfile["hash"],
              hashedRt: studentProfile["hashedRt"],
              surah_name: "Al-Fatiha",
              ayah_number: studentProfile["ayah_number"],
              role: studentProfile["role"],
              classId: studentProfile["classId"],
              isPresent: studentProfile["isPresent"],
              isSaved: studentProfile["isSaved"],
              avatar: studentProfile["avatarUrl"]);
          students.add(student);
        }
        emit(EvaluationSuccessState(students: students));
      } catch (error) {
        print(error.toString());
        emit(UstazProfileError(error.toString()));
      }
    }));

    on<OnSaveEvent>((event, emit) async {
      // if (state is UserProfileLoading) return;
      try {
        if (!event.student.isPresent) {
          await ustazRepository.addabscent(
              event.student.id, event.student.classId, event.date);

          final studentProfile =
              await ustazRepository.updateUserProfile(event.student);

          Student student = Student(
              id: studentProfile["_id"],
              fullName: studentProfile["fullName"],
              email: studentProfile['email'],
              country: studentProfile["country"],
              sex: studentProfile["sex"],
              kirat_type: studentProfile["kirat_type"],
              hash: studentProfile["hash"],
              hashedRt: studentProfile["hashedRt"],
              surah_name: studentProfile["surah_name"],
              ayah_number: studentProfile["ayah_number"],
              role: studentProfile["role"],
              classId: studentProfile["classId"],
              isSaved: studentProfile["isSaved"],
              isPresent: studentProfile["isPresent"],
              avatar: studentProfile["avatarUrl"]);

          var studentProfiles =
              await ustazRepository.fetchstudents(event.student.classId);
          print(studentProfiles);

          List<Student> students = [];

          for (var studentProfile in studentProfiles) {
            Student student = Student(
                id: studentProfile["_id"],
                fullName: studentProfile["fullName"],
                email: studentProfile['email'],
                country: studentProfile["country"],
                sex: studentProfile["sex"],
                kirat_type: studentProfile["kirat_type"],
                hash: studentProfile["hash"],
                hashedRt: studentProfile["hashedRt"],
                surah_name: "Al-Fatiha",
                ayah_number: studentProfile["ayah_number"],
                role: studentProfile["role"],
                classId: studentProfile["classId"],
                isPresent: studentProfile["isPresent"],
                isSaved: studentProfile["isSaved"],
                avatar: studentProfile["avatarUrl"]);
            students.add(student);
          }
          emit(SaveSuccessState(students));
        } else {
          final studentProfile =
              await ustazRepository.updateUserProfile(event.student);

          Student student = Student(
              id: studentProfile["_id"],
              fullName: studentProfile["fullName"],
              email: studentProfile['email'],
              country: studentProfile["country"],
              sex: studentProfile["sex"],
              kirat_type: studentProfile["kirat_type"],
              hash: studentProfile["hash"],
              hashedRt: studentProfile["hashedRt"],
              surah_name: studentProfile["surah_name"],
              ayah_number: studentProfile["ayah_number"],
              role: studentProfile["role"],
              classId: studentProfile["classId"],
              isSaved: studentProfile["isSaved"],
              isPresent: studentProfile["isPresent"],
              avatar: studentProfile["avatarUrl"]);

          await ustazRepository.addmark(
              event.student.id,
              event.date,
              event.student.score,
              event.student.ayah_number,
              event.student.surah_name);

          var studentProfiles =
              await ustazRepository.fetchstudents(event.student.classId);
          print(studentProfiles);

          List<Student> students = [];

          for (var studentProfile in studentProfiles) {
            Student student = Student(
                id: studentProfile["_id"],
                fullName: studentProfile["fullName"],
                email: studentProfile['email'],
                country: studentProfile["country"],
                sex: studentProfile["sex"],
                kirat_type: studentProfile["kirat_type"],
                hash: studentProfile["hash"],
                hashedRt: studentProfile["hashedRt"],
                surah_name: "Al-Fatiha",
                ayah_number: studentProfile["ayah_number"],
                role: studentProfile["role"],
                classId: studentProfile["classId"],
                isPresent: studentProfile["isPresent"],
                isSaved: studentProfile["isSaved"],
                avatar: studentProfile["avatarUrl"]);
            students.add(student);
          }
          emit(SaveSuccessState(students));
        }
      } catch (error) {
        emit(SaveFailureState('Failed to load user profile: $error'));
      }
    });

    on<NewDayEvent>((event, emit) async {
      try {
        for (var student in event.students) {
          final studentProfile =
              await ustazRepository.updateUserProfile(student);
        }

        var studentProfiles =
            await ustazRepository.fetchstudents(event.students[0].classId);
        print(studentProfiles);

        List<Student> students = [];

        for (var studentProfile in studentProfiles) {
          Student student = Student(
              id: studentProfile["_id"],
              fullName: studentProfile["fullName"],
              email: studentProfile['email'],
              country: studentProfile["country"],
              sex: studentProfile["sex"],
              kirat_type: studentProfile["kirat_type"],
              hash: studentProfile["hash"],
              hashedRt: studentProfile["hashedRt"],
              surah_name: "Al-Fatiha",
              ayah_number: studentProfile["ayah_number"],
              role: studentProfile["role"],
              classId: studentProfile["classId"],
              isPresent: studentProfile["isPresent"],
              isSaved: studentProfile["isSaved"],
              avatar: studentProfile["avatarUrl"]);
          students.add(student);
        }
        emit(NewDayState(students));
      } catch (error) {
        emit(UndoFailureState('Failed to load user profile: $error'));
      }
    });

    on<OnUndoEvent>((event, emit) async {
      // if (state is UserProfileLoading) return;
      try {
        if (!event.student.isPresent) {
          final studentProfile =
              await ustazRepository.updateUserProfile(event.student);
          print(studentProfile);

          final abscent = 
              await ustazRepository.deleteabscent(event.student.id, event.date);

          print("abscent");

          Student student = Student(
              id: studentProfile["_id"],
              fullName: studentProfile["fullName"],
              email: studentProfile['email'],
              country: studentProfile["country"],
              sex: studentProfile["sex"],
              kirat_type: studentProfile["kirat_type"],
              hash: studentProfile["hash"],
              hashedRt: studentProfile["hashedRt"],
              surah_name: studentProfile["surah_name"],
              ayah_number: studentProfile["ayah_number"],
              role: studentProfile["role"],
              classId: studentProfile["classId"],
              isSaved: studentProfile["isSaved"],
              isPresent: studentProfile["isPresent"],
              avatar: studentProfile["avatarUrl"]);

          var studentProfiles =
              await ustazRepository.fetchstudents(event.student.classId);
          print(studentProfiles);

          List<Student> students = [];

          for (var studentProfile in studentProfiles) {
            Student student = Student(
                id: studentProfile["_id"],
                fullName: studentProfile["fullName"],
                email: studentProfile['email'],
                country: studentProfile["country"],
                sex: studentProfile["sex"],
                kirat_type: studentProfile["kirat_type"],
                hash: studentProfile["hash"],
                hashedRt: studentProfile["hashedRt"],
                surah_name: "Al-Fatiha",
                ayah_number: studentProfile["ayah_number"],
                role: studentProfile["role"],
                classId: studentProfile["classId"],
                isPresent: studentProfile["isPresent"],
                isSaved: studentProfile["isSaved"],
                 avatar: studentProfile["avatarUrl"]);
            students.add(student);
          }
          emit(UndoSuccessState(students));
        } else {
          event.student.isPresent = false;
          final studentProfile =
              await ustazRepository.updateUserProfile(event.student);

          Student student = Student(
              id: studentProfile["_id"],
              fullName: studentProfile["fullName"],
              email: studentProfile['email'],
              country: studentProfile["country"],
              sex: studentProfile["sex"],
              kirat_type: studentProfile["kirat_type"],
              hash: studentProfile["hash"],
              hashedRt: studentProfile["hashedRt"],
              surah_name: studentProfile["surah_name"],
              ayah_number: studentProfile["ayah_number"],
              role: studentProfile["role"],
              classId: studentProfile["classId"],
              isSaved: studentProfile["isSaved"],
              isPresent: studentProfile["isPresent"],
               avatar: studentProfile["avatarUrl"]);

          print("object1");

          await ustazRepository.deltemark(
            event.student.id,
            event.date,
          );

          print("object2");
          var studentProfiles =
              await ustazRepository.fetchstudents(event.student.classId);
          print(studentProfiles);

          List<Student> students = [];

          for (var studentProfile in studentProfiles) {
            Student student = Student(
                id: studentProfile["_id"],
                fullName: studentProfile["fullName"],
                email: studentProfile['email'],
                country: studentProfile["country"],
                sex: studentProfile["sex"],
                kirat_type: studentProfile["kirat_type"],
                hash: studentProfile["hash"],
                hashedRt: studentProfile["hashedRt"],
                surah_name: "Al-Fatiha",
                ayah_number: studentProfile["ayah_number"],
                role: studentProfile["role"],
                classId: studentProfile["classId"],
                isPresent: studentProfile["isPresent"],
                isSaved: studentProfile["isSaved"],
                 avatar: studentProfile["avatarUrl"]);
            students.add(student);
          }
          emit(UndoSuccessState(students));
        }
      } catch (error) {
        emit(UndoFailureState('Failed to load user profile: $error'));
      }
    });

    on<UstazLogOutButtonPressed>(
      (event, emit) async {
        // if (state is LogOutLoading) return;

        // Future.delayed(Duration(seconds: delay));
        try {
          // LoginCredentials loginCredentials = LoginCredentials();
          print("logout");
          UstazLoginCredentials ustazloginCredentials = UstazLoginCredentials();
          ustazloginCredentials.deleteLoginCredentials();

          emit(LogOutSuccessState());
          // emit( LoginLoadingState());
        } catch (error) {
          emit(LogOutFailureState(error: error));
        }
      },
    );
  }
}
