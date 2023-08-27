import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/admin/admin_model.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_event.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_state.dart';
import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../../admin/admin_login_details_model.dart';
import '../../../admin/db.dart';
import '../../../ustaz/models/ustaz_login_details_model.dart';
import '../../../ustaz/ustaz_data_provider/ustaz_db.dart';
import '../../data_providers/local_db/db.dart';
import '../../models/login_details.dart';
import '../../models/student.dart';
import '../../models/token_model.dart';
import '../../repository/student_repository.dart';

class LoginBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  LoginBloc({required this.studentRepository}) : super(LoginLoadingState()) {
    on<LoginButtonPressed>((event, emit) async {
      // if (state is LoginLoading) return;
      emit(LoginOperationLoadingState());
      // Future.delayed(Duration(seconds: delay));
      try {
        final response = await studentRepository.login(event.loginModel);

        if (response[0]['role'] == "deresa") {
          final Token token = Token.create(
            response[0]['access_token'],
            response[0]['refresh_token'],
          );

          final Map<String, dynamic> user = response[1];
          print(user);
          final Student realUser = Student.mapFromJson(user);
          // final String role = decodedResponse['role'];
          LoginDetailsModel loginDetailsModel =
              LoginDetailsModel.create(token, realUser);
          LoginCredentials loginCredentials = LoginCredentials();
          loginCredentials.insertLoginCredentials(loginDetailsModel);
          emit(LoginSuccessState(loginDetailsModel: loginDetailsModel));
        } else if (response[0]['role'] == "ustaz") {
          final Token token = Token.create(
            response[0]['access_token'],
            response[0]['refresh_token'],
          );

          final Map<String, dynamic> user = response[1];
          print(user);
          final Ustaz realUser = Ustaz.mapFromJson(user);
          // final String role = decodedResponse['role'];
          UstazLoginDetailsModel ustazloginDetailsModel =
              UstazLoginDetailsModel.create(token, realUser);
          UstazLoginCredentials ustazloginCredentials = UstazLoginCredentials();
          ustazloginCredentials.insertLoginCredentials(ustazloginDetailsModel);
          emit(UstazLoginSuccessState(
              ustazloginDetailsModel: ustazloginDetailsModel));
        } else if (response[0]['role'] == "admin") {
          final Token token = Token.create(
            response[0]['access_token'],
            response[0]['refresh_token'],
          );

          final Map<String, dynamic> user = response[1];
          print(user);
          final Admin realUser = Admin.mapFromJson(user);
          // final String role = decodedResponse['role'];
          AdminLoginDetailsModel adminloginDetailsModel =
              AdminLoginDetailsModel.create(token, realUser);
          AdminLoginCredentials adminloginCredentials = AdminLoginCredentials();
          adminloginCredentials.insertLoginCredentials(adminloginDetailsModel);
          emit(AdminLoginSuccessState(
              adminloginDetailsModel: adminloginDetailsModel));
        }
      } catch (error) {
        emit(LoginFailureState(error: error));
      }
    });

    on<LogOutButtonPressed>(
      (event, emit) async {
        // if (state is LogOutLoading) return;
        // Future.delayed(Duration(seconds: delay));
        try {
          if (event.role == "admin") {
            AdminLoginCredentials adminloginCredentials =
                AdminLoginCredentials();
            adminloginCredentials.deleteLoginCredentials();
          } else if (event.role == "ustaz") {
            UstazLoginCredentials ustazloginCredentials =
                UstazLoginCredentials();
            ustazloginCredentials.deleteLoginCredentials();
          } else {
            LoginCredentials loginCredentials = LoginCredentials();
            loginCredentials.deleteLoginCredentials();
          }
         
          emit(LoginLoadingState());

          // emit( LoginLoadingState());
        } catch (error) {
          emit(LogOutFailureState(error: error));
        }
      },
    );

    // on<AdminLogOutButtonPressed>(
    //   (event, emit) async {
    //     // if (state is LogOutLoading) return;
    //     emit(LogOutLoadingState());
    //     // Future.delayed(Duration(seconds: delay));
    //     try {
    //       // LoginCredentials loginCredentials = LoginCredentials();
    //       await studentRepository.logout(event.email);

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
