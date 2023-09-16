import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_quran_frontend/student/presentation/screens/profile_error_page.dart';
import 'package:online_quran_frontend/student/presentation/screens/student_evaluation.dart';
import 'package:online_quran_frontend/student/presentation/screens/student_evaluation_try.dart';
import 'package:online_quran_frontend/ustaz/blocs/ustaz_bloc/blocs.dart';
import 'package:online_quran_frontend/ustaz/ustaz_data_provider/ustaz_data_provider.dart';
import 'package:online_quran_frontend/ustaz/ustaz_repository/ustaz_repository.dart';

import '../../../ustaz/blocs/ustaz_bloc/ustaz_bloc.dart';
import '../../../ustaz/models/ustaz_login_details_model.dart';
import '../../../ustaz/ustaz_data_provider/ustaz_db.dart';
import '../../blocs/student_bloc/login_bloc.dart';
import '../../blocs/student_bloc/student_event.dart';

class UstazProfileScreen extends StatefulWidget {
  const UstazProfileScreen({
    super.key,
  });

  @override
  State<UstazProfileScreen> createState() => ProfileState();
}

class ProfileState extends State<UstazProfileScreen> {
  UstazBloc ustazBloc = UstazBloc(
      ustazRepository: UstazRepository(ustazdataProvider: UstazDataProvider()));

  // @override
  // void initState() {
  //   loginBloc.add(LoadLogin());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UstazBloc, UstazState>(
      listener: (context, state) {
        // if (state is LoginSuccess) {
        //   GoRouter.of(context).pushReplacement("/");
        // } else
        if (state is EvaluationFetchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cant fetch students"),
            ),
          );
        }
      },
      builder: (context, state) {
        print("here is it: ${state.runtimeType}");
        switch (state.runtimeType) {
          case EvaluationLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case UstazProfileLoadSuccess:
          case EvaluationFetchFailure:
            return UstazProfileScreenBody();
          case EvaluationSuccessState:
            final evaluationSuccessState = state as EvaluationSuccessState;
            return WhiteScreen(evaluationSuccessState.students);
          // case UstazLoginSuccessState:
          //   return UstazProfileScreen();
          default:
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
        }
      },
    ));
  }
}

class UstazProfileScreenBody extends StatelessWidget {
  Future<UstazLoginDetailsModel?> fetchLocalUser() async {
    UstazLoginCredentials ustazloginCredentials = UstazLoginCredentials();
    return await ustazloginCredentials.getLoginCredentials();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: fetchLocalUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              backgroundColor: Color.fromARGB(255, 36, 36, 37),
              title: Text(
                'You',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  BlocProvider.of<LoginBloc>(context).add(
                                      LogOutButtonPressed(
                                          role: snapshot.data!.ustaz.role));

                                  GoRouter.of(context).push("/login");
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.only(
                top: size.height * 0.05,
              ),
              // ignore: prefer_const_constructors
              width: size.height,
              height: size.width * 2,
              decoration: BoxDecoration(color: Color(0xFF1a1d22)),
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Text(
                      "Welcome back,",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              snapshot.data!.ustaz.avatar),
                        ),
                      ),
                    ),
                    Text(
                      '${snapshot.data!.ustaz.fullName}',
                      style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 185, 183, 167),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 40),
                    Text(
                      'Your class: ${snapshot.data!.ustaz.classId}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Evaluate"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 8, 119,
                            101), // set the button background color
                        onPrimary: Colors.white, // set the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // set the button border radius
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      onPressed: () {
                        //validation for register
                        BlocProvider.of<UstazBloc>(context).add(
                          EvaluateButtonPressed(
                            classId: snapshot.data!.ustaz.classId,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const ErrorPage();
        }
      },
    );
  }
}
