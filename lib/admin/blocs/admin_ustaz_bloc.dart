import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../student/data_providers/image_picker.dart';
import '../../student/models/student.dart';
import '../../student/repository/student_repository.dart';
import '../../ustaz/ustaz_repository/ustaz_repository.dart';
import '../db.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminUstazBloc extends Bloc<AdminEvent, AdminState> {
  final StudentRepository studentRepository;
  final UstazRepository ustazRepository;

  AdminUstazBloc(
      {required this.studentRepository, required this.ustazRepository})
      : super(AdminUstazLoading()) {
    on<InitustazEvent>((event, emit) async {
      // emit(AdminUstazLoading());
      try {
        var ustazProfiles = await ustazRepository.fetchallustazes();
        print(ustazProfiles);
        print(ustazProfiles);
        List<Ustaz> ustazes = [];

        for (var ustazProfile in ustazProfiles) {
          Ustaz ustaz = Ustaz(
              id: ustazProfile["_id"],
              fullName: ustazProfile["fullName"],
              email: ustazProfile['email'],
              hash: ustazProfile["hash"],
              hashedRt: ustazProfile["hashedRt"],
              role: ustazProfile["role"],
              classId: ustazProfile["classId"],
              avatar: ustazProfile["avatar"]);
          ustazes.add(ustaz);
        }
        emit(IntialUstazsState(ustazs: ustazes));
      } catch (error) {
        emit(InitialUstazFailureState(
            message: 'Failed to fetch Ustazes: $error'));
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


    on<AddUstazButton>(((event, emit) async {
      try {
        emit(StudentOperationProgress());

        await ustazRepository.signupUstaz(event.ustazsignUpModel);
        var ustazProfiles = await ustazRepository.fetchallustazes();
        print(ustazProfiles);

        List<Ustaz> ustazes = [];

        for (var ustazProfile in ustazProfiles) {
          Ustaz ustaz = Ustaz(
              id: ustazProfile["_id"],
              fullName: ustazProfile["fullName"],
              email: ustazProfile['email'],
              hash: ustazProfile["hash"],
              hashedRt: ustazProfile["hashedRt"],
              role: ustazProfile["role"],
              classId: ustazProfile["classId"],
              avatar: ustazProfile["avatar"]);
          ustazes.add(ustaz);
        }

        emit(UstazAddOperationSuccess(ustazs: ustazes));
      } catch (error) {
        print(error.toString());
        emit(UstazOperationFailure(message: error.toString()));
      }
    }));

    on<UpdateUstazButton>(((event, emit) async {
      
      try {
        emit(StudentOperationProgress());

        final ustazProfile =
            await ustazRepository.updateustazProfile(event.ustaz);
        var ustazProfiles = await ustazRepository.fetchallustazes();
        print(ustazProfiles);

        List<Ustaz> ustazes = [];

        for (var ustazProfile in ustazProfiles) {
          Ustaz ustaz = Ustaz(
              id: ustazProfile["_id"],
              fullName: ustazProfile["fullName"],
              email: ustazProfile['email'],
              hash: ustazProfile["hash"],
              hashedRt: ustazProfile["hashedRt"],
              role: ustazProfile["role"],
              classId: ustazProfile["classId"],
              avatar: ustazProfile["avatar"]);
          ustazes.add(ustaz);
        }

        emit(UstazUpdateOperationSuccess(ustazs: ustazes));
      } catch (error) {
        print(error.toString());
        emit(UstazOperationFailure(message: error.toString()));
      }
    }));

    on<DeleteUstazButtonPressed>(((event, emit) async {
      try {
        print("Sertual");

        await studentRepository.deleteustaz(event.email);
        var ustazProfiles = await ustazRepository.fetchallustazes();
        print(ustazProfiles);

        List<Ustaz> ustazes = [];

        for (var ustazProfile in ustazProfiles) {
          Ustaz ustaz = Ustaz(
              id: ustazProfile["_id"],
              fullName: ustazProfile["fullName"],
              email: ustazProfile['email'],
              hash: ustazProfile["hash"],
              hashedRt: ustazProfile["hashedRt"],
              role: ustazProfile["role"],
              classId: ustazProfile["classId"],
              avatar: ustazProfile["avatar"]);
          ustazes.add(ustaz);
        }
        emit(UstazDeleteOperationSuccess(ustazs: ustazes));
      } catch (error) {
        print(error.toString());
        emit(UstazOperationFailure(message: error.toString()));
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
