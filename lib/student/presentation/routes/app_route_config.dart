import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_quran_frontend/student/presentation/screens/student_profile_screen.dart';
import 'package:online_quran_frontend/ustaz/ustaz_data_provider/ustaz_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_providers/local_db/db.dart';
import '../screens/admin__profile_screen.dart';
import '../screens/admin_class_screen.dart';
import '../screens/admin_ustaz_screen.dart';
import '../screens/modification.dart';
import '../screens/student_abscent_screen.dart';
import '../screens/student_evaluation.dart';
import '../screens/login_page.dart';
import '../screens/signup_page.dart';
import '../screens/student_evaluation_try.dart';
import '../screens/student_score_screen.dart';
import '../screens/ustaz_profile_screen.dart';

class MyAppRouter {
  static GoRouter returnRouter(bool isLoggedIn) {
    Future<SharedPreferences> init() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs;
    }

    Widget Screen = StudentProfileScreen();

    Future<Widget> getScreen() async {
      try {
        LoginCredentials loginCredentials = LoginCredentials();
        UstazLoginCredentials ustazloginCredentials = UstazLoginCredentials();
        if (isLoggedIn) {
          final SharedPreferences prefs = await init();

          String? role = prefs.getString("role");
          if (role == "deresa") {
            Screen = StudentProfileScreen();
          } else if (role == "ustaz") {
            print("hello Ustazzz");

            Screen = UstazProfileScreen();
          } else if (role == "admin") {
            print("Hello Admin");
            Screen = AdminProfileScreen();
          } else {
            print("heloo");
          }
        }
      } catch (error) {
        print("Error occurred: $error");
      }
      return Screen;
    }

    print(isLoggedIn);
    GoRouter router = GoRouter(
      // initialLocation: isLoggedIn ? "/home" : "/login",
      // initialLocation: "/profile",
      routes: [
        GoRoute(
          name: 'initial',
          path: '/',
          pageBuilder: (context, state) {
            return
                // MaterialPage(child: StudentProfileScreen_2());
                MaterialPage(
                    child: FutureBuilder<Widget>(
              future: getScreen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return isLoggedIn ? snapshot.data! : const LogIn();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ));
          },
        ),
        GoRoute(
          name: 'login',
          path: "/login",
          pageBuilder: (context, state) {
            return const MaterialPage(child: LogIn());
          },
        ),
        GoRoute(
            name: 'signup',
            path: "/register",
            pageBuilder: ((context, state) {
              return const MaterialPage(child: MyRegister());
            })),
        // GoRoute(
        //     name: 'StudentEvaluation',
        //     path: "/Evalute",
        //     pageBuilder: ((context, state) {
        //       return MaterialPage(child: WhiteScreen());
        //     })),
        GoRoute(
            name: 'studentprofile',
            path: "/studentprofile",
            pageBuilder: ((context, state) {
              return MaterialPage(child: StudentProfileScreen());
            })),
        GoRoute(
            name: 'studentprofile_2',
            path: "/studentprofile_2",
            pageBuilder: ((context, state) {
              return MaterialPage(child: StudentProfileScreen_2());
            })),

        GoRoute(
            name: 'abscentscreen',
            path: "/abscentscreen",
            pageBuilder: ((context, state) {
              return MaterialPage(child: StudentAbscentScreen());
            })),
        GoRoute(
            name: 'scorescreen',
            path: "/scorescreen",
            pageBuilder: ((context, state) {
              return MaterialPage(child: StudentScoreScreen());
            })),
        GoRoute(
            name: 'ustazprofile',
            path: "/ustazprofile",
            pageBuilder: ((context, state) {
              return MaterialPage(child: UstazProfileScreen());
            })),
        GoRoute(
            name: 'managestudent',
            path: "/managestudent",
            pageBuilder: ((context, state) {
              return MaterialPage(child: AdminProfileScreen());
            })),
        GoRoute(
            name: 'manageustaz',
            path: "/manageustaz",
            pageBuilder: ((context, state) {
              return MaterialPage(child: AdminUstazScreen());
            })),
        GoRoute(
            name: 'manageclass',
            path: "/manageclass",
            pageBuilder: ((context, state) {
              return MaterialPage(child: AdminClassScreen());
            })),
      ],
    );
    return router;
  }
}
