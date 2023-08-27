import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/admin/blocs/admin_student_bloc.dart';
import 'package:online_quran_frontend/student/bloc_observer.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/login_bloc.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/signup_bloc.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_profile_bloc.dart';
import 'package:online_quran_frontend/student/data_providers/local_db/db.dart';
import 'package:online_quran_frontend/student/data_providers/student_data_provider.dart';
import 'package:online_quran_frontend/student/presentation/routes/app_route_config.dart';
import 'package:online_quran_frontend/student/repository/student_repository.dart';
import 'package:online_quran_frontend/ustaz/blocs/ustaz_bloc/ustaz_bloc.dart';
import 'package:online_quran_frontend/ustaz/ustaz_data_provider/ustaz_data_provider.dart';
import 'package:online_quran_frontend/ustaz/ustaz_data_provider/ustaz_db.dart';
import 'package:online_quran_frontend/ustaz/ustaz_repository/ustaz_repository.dart';

import 'admin/blocs/admin_class_bloc.dart';
import 'admin/blocs/admin_ustaz_bloc.dart';
import 'admin/db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LoginCredentials loginCredentials = LoginCredentials();
  final UstazLoginCredentials ustazloginCredentials = UstazLoginCredentials();
  final AdminLoginCredentials adminloginCredentials = AdminLoginCredentials();
  bool isLoggedIn = (await loginCredentials.getLoginCredentials()) != null ||
      (await ustazloginCredentials.getLoginCredentials()) != null || (await adminloginCredentials.getLoginCredentials()) != null;
  final StudentRepository studentRepository =
      StudentRepository(dataProvider: StudentDataProvider());
  final UstazRepository ustazRepository =
      UstazRepository(ustazdataProvider: UstazDataProvider());

  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp(
    studentRepository: studentRepository,
    isLoggedIn: isLoggedIn,
    ustazRepository: ustazRepository,
  ));
}

class MyApp extends StatelessWidget {
  final StudentRepository studentRepository;
  final UstazRepository ustazRepository;

  final bool isLoggedIn;

  const MyApp({
    Key? key,
    required this.studentRepository,
    required this.isLoggedIn,
    required this.ustazRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentBloc>(
          create: (context) =>
              StudentBloc(studentRepository: studentRepository),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(studentRepository: studentRepository),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(studentRepository: studentRepository),
        ),
        BlocProvider<UstazBloc>(
          create: (context) => UstazBloc(ustazRepository: ustazRepository),
        ),
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(studentRepository:studentRepository, ustazRepository: ustazRepository),
        ),
        BlocProvider<AdminUstazBloc>(
          create: (context) => AdminUstazBloc(studentRepository:studentRepository, ustazRepository: ustazRepository),
        ),
        BlocProvider<AdminClassBloc>(
          create: (context) => AdminClassBloc(studentRepository:studentRepository, ustazRepository: ustazRepository),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // theme: darkTheme(),
        routeInformationParser:
            MyAppRouter.returnRouter(isLoggedIn).routeInformationParser,
        routerDelegate: MyAppRouter.returnRouter(isLoggedIn).routerDelegate,
      ),
    );
  }
}
