import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../student/data_providers/image_picker.dart';
import '../../student/models/student.dart';
import '../../student/repository/student_repository.dart';
import '../../ustaz/ustaz_repository/ustaz_repository.dart';
import '../db.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final StudentRepository studentRepository;
  final UstazRepository ustazRepository;

  AdminBloc({required this.studentRepository, required this.ustazRepository})
      : super(AdminScreenLoading()) {
    on<InitstudentsEvent>((event, emit) async {
      emit(AdminScreenLoading());
      try {
        var studentProfiles = await ustazRepository.fetchallstudents();
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
              avatar: studentProfile["avatarUrl"]
              );
          students.add(student);
        }
        emit(IntialStudentsState(students: students));
      } catch (error) {
        emit(InitialFailureState(
            message: 'Failed to load user profile: $error'));
      }
    });

    on<AddImage>((event, emit) async {
      emit(ImageOperationProgress());
      try {
        var _avatarImageUrl = await UploadImage.pickImage();
        print("real${_avatarImageUrl}");

        

        emit(ImageAddSuccess(avatar: _avatarImageUrl!));
      } catch (error) {
        emit(ImageAddFailure(
            message: 'Failed to load user profile: $error'));
      }
    });

    on<AddStudentButton>(((event, emit) async {
      try {
        emit(StudentOperationProgress());
        await studentRepository.signup(event.signUpModel);
        var studentProfiles = await ustazRepository.fetchallstudents();
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
              avatar: studentProfile["avatarUrl"]
              
              );
          students.add(student);
        }

        emit(StudentAddOperationSuccess(students: students));
      } catch (error) {
        print(error.toString());
        emit(StudentOperationFailure(message: error.toString()));
      }
    }));

    on<UpdateStudentButton>(((event, emit) async {
      try {
        emit(StudentOperationProgress());

        print(event.student.fullName);
        final studentProfile =
            await ustazRepository.updateUserProfile(event.student);
        var studentProfiles = await ustazRepository.fetchallstudents();
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
              avatar: studentProfile["avatarUrl"]
              );
          students.add(student);
        }

        emit(StudentUpdateOperationSuccess(students: students));
      } catch (error) {
        print(error.toString());
        emit(StudentOperationFailure(message: error.toString()));
      }
    }));

    on<DeleteButtonPressed>(((event, emit) async {
      try {
        print("Sertual");

        await studentRepository.deletestudent(event.email);
        var studentProfiles = await ustazRepository.fetchallstudents();
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
              avatar: studentProfile["avatarUrl"]
              );
          students.add(student);
        }

        emit(StudentOperationSuccess(students: students));
      } catch (error) {
        print(error.toString());
        emit(StudentOperationFailure(message: error.toString()));
      }
    }));

    // on<AdminLogOutButtonPressed>(
    //   (event, emit) async {
    //     // if (state is LogOutLoading) return;
    //     // Future.delayed(Duration(seconds: delay));
    //     try {

    //       // LoginCredentials loginCredentials = LoginCredentials();
    //       print("logout");
    //       AdminLoginCredentials adminloginCredentials = AdminLoginCredentials();
    //       adminloginCredentials.deleteLoginCredentials();

    //       emit(LogOutSuccessState());
    //       // emit( LoginLoadingState());
    //     } catch (error) {
    //       emit(LogOutFailureState(error: error));
    //     }
    //   },
    // );
  }
}
