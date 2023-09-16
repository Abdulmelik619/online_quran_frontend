import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/login_bloc.dart';
import 'package:online_quran_frontend/student/models/signup_model.dart';
import 'package:online_quran_frontend/student/presentation/screens/student_profile_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../admin/blocs/admin_student_bloc.dart';
import '../../../admin/blocs/admin_event.dart';
import '../../../admin/blocs/admin_state.dart';
import '../../../admin/class_model.dart';
import '../../../ustaz/ustaz_data_provider/ustaz_data_provider.dart';
import '../../../ustaz/ustaz_repository/ustaz_repository.dart';
import '../../blocs/student_bloc/student_event.dart';
import '../../blocs/student_bloc/student_profile_bloc.dart';
import '../../blocs/student_bloc/student_state.dart';
import '../../data_providers/local_db/db.dart';
import '../../data_providers/student_data_provider.dart';
import '../../models/abscent.dart';
import '../../models/login_details.dart';
import '../../models/student.dart';
import '../../repository/student_repository.dart';
import '../components/edit_profile_body.dart';
import '../components/list_of_surah.dart';
import '../components/signup_body.dart';
import 'login_page.dart';

// class Student {
//   final int id;
//   final String name;
//   final String email;

//   const Student({required this.id, required this.name, required this.email});
// }

class StudentAbscentScreen extends StatefulWidget {
  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<StudentAbscentScreen> {
  List<String> abscents = [
    "Monday 12 April",
    "Wednsday 13 April",
    "Friday 15 April"
  ];

  final _searchController = TextEditingController();

  final Color backgroundColor = Color.fromARGB(255, 31, 34, 36);

  Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  late Timer _timer;
  String idGlobal = '';

  Future<void> setId() async {
    final SharedPreferences prefs = await init();

    String? id = prefs.getString("id");
    setState(() {
      idGlobal = id!;
    });
  }

  @override
  initState() {
    setId();
    const oneHour = Duration(hours: 1);
    const fiveMinutes = Duration(minutes: 3);

    _timer = Timer.periodic(oneHour, (timer) {
      BlocProvider.of<StudentBloc>(context).add(StudentAbscentLoadEvent(
        id: idGlobal,
      ));
    });
    super.initState();
  }

  List<Abscent> abscents_fetched = [];

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).push("/studentprofile_2");

        break;
      case 1:
        GoRouter.of(context).push("/abscentscreen");

        break;
      case 2:
        GoRouter.of(context).push("/scorescreen");

        break;
    }
  }

  Future<LoginDetailsModel?> fetchLocalUser() async {
    LoginCredentials loginCredentials = LoginCredentials();
    return await loginCredentials.getLoginCredentials();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = true;

    return FutureBuilder(
        future: fetchLocalUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocConsumer<StudentBloc, StudentState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is StudentProfileLoadingState) {
                    // BlocProvider.of<StudentBloc>(context).add(
                    //     StudentProfileLoadEvent(
                    //         email: snapshot.data!.student.email));
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is StudentScoreLoadingState) {
                    // BlocProvider.of<StudentBloc>(context).add(
                    //     StudentProfileLoadEvent(
                    //         email: snapshot.data!.student.email));
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is StudentAbscentLoadSuccess) {
                    abscents_fetched = state.abscents;
                    return WillPopScope(
                      onWillPop: () async {
                        // Custom back button behavior
                        // Navigate to the previous screen

                        BlocProvider.of<StudentBloc>(context)
                            .add(Navigate(email: snapshot.data!.student.email));
                        GoRouter.of(context).push("/studentprofile");
                        return false; // Return 'false' to prevent the default back button behavior
                      },
                      child: Scaffold(
                          bottomNavigationBar: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 0.1,
                                color: Colors
                                    .grey[300], // set the color of the line
                              ),
                              BottomNavigationBar(
                                backgroundColor: Color(0xFF1a1d22),
                                items: const <BottomNavigationBarItem>[
                                  BottomNavigationBarItem(
                                    backgroundColor: Colors.white,
                                    icon: Icon(
                                      Icons.home_outlined,
                                    ),
                                    label: 'Home  ',
                                  ),
                                  BottomNavigationBarItem(
                                    backgroundColor: Colors.white,
                                    icon: Icon(
                                      Icons.people_outlined,
                                    ),
                                    label: 'Abscents',
                                  ),
                                  BottomNavigationBarItem(
                                    backgroundColor: Colors.white,
                                    icon: Icon(
                                      Icons.score_outlined,
                                    ),
                                    label: 'Score',
                                  ),
                                ],
                                currentIndex: _selectedIndex,
                                onTap: (int index) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });

                                  switch (index) {
                                    case 0:
                                      BlocProvider.of<StudentBloc>(context).add(
                                          Navigate(
                                              email: snapshot
                                                  .data!.student.email));
                                      GoRouter.of(context)
                                          .push("/studentprofile");
                                      break;
                                    case 1:
                                      BlocProvider.of<StudentBloc>(context).add(
                                          StudentAbscentLoadEvent(
                                              id: snapshot.data!.student.id));

                                      GoRouter.of(context)
                                          .push("/abscentscreen");
                                      break;
                                    case 2:
                                      BlocProvider.of<StudentBloc>(context).add(
                                          StudentScoreLoadEvent(
                                              id: snapshot.data!.student.id));

                                      GoRouter.of(context).push("/scorescreen");
                                      break;
                                  }
                                },
                                type: BottomNavigationBarType.fixed,
                                selectedItemColor: Colors.blue,
                                selectedIconTheme: IconThemeData(
                                  color: Colors.blue,
                                ),
                                unselectedItemColor: Colors.white,
                                unselectedLabelStyle: GoogleFonts.poppins(
                                  color: true
                                      ? Colors.white
                                      : const Color(0xff1D1617),
                                  fontSize: size.height * 0.015,
                                ),
                              ),
                            ],
                          ),
                          body: MaterialApp(
                            home: Container(
                              child: Scaffold(
                                body: Container(
                                  height: size.height,
                                  width: size.width * 1.1,
                                  decoration:
                                      BoxDecoration(color: Color(0xFF1a1d22)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(height: 16),
                                          abscents.length == 0
                                              ? SizedBox(height: 0, width: 0)
                                              : Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 14, 0, 14),
                                                  child: Text(
                                                    "Student A has been Abscent the following days: ",
                                                    style: GoogleFonts.poppins(
                                                        color: true
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff1D1617),
                                                        fontSize:
                                                            size.height * 0.022,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                          Expanded(
                                            child: abscents_fetched.length == 0
                                                ? Center(
                                                    child: Text(
                                                      'No abscents till Today',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.green,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    // decoration: BoxDecoration(color: Color.fromARGB(255, 31, 34, 36)),

                                                    child: ListView.builder(
                                                      itemCount:
                                                          abscents_fetched
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var itemnumber =
                                                            index + 1;
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                "${itemnumber}. ${abscents_fetched[index].date}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: true
                                                                      ? Colors
                                                                          .white
                                                                      : const Color(
                                                                          0xff1D1617),
                                                                  fontSize:
                                                                      size.height *
                                                                          0.022,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 0.3,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    );
                  } else {
                    return const StudentErrorPage();
                  }
                });
          } else {
            return const StudentErrorPage();
          }
        });
  }
}
