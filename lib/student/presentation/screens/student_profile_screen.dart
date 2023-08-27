import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_state.dart';
import 'package:online_quran_frontend/student/presentation/screens/student_profile_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/student_bloc/login_bloc.dart';
import '../../blocs/student_bloc/student_event.dart';
import '../../blocs/student_bloc/student_profile_bloc.dart';
import '../../data_providers/local_db/db.dart';
import '../../models/login_details.dart';

class StudentProfileScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<StudentProfileScreen> {
  Future<LoginDetailsModel?> fetchLocalUser() async {
    LoginCredentials loginCredentials = LoginCredentials();
    return await loginCredentials.getLoginCredentials();
  }

  Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<void> setEmail() async {
    final SharedPreferences prefs = await init();

    String? email = prefs.getString("email");
    setState(() {
      emailglobal = email!;
    });
  }

  bool _isPresent = false;
  int _score = 0;
  String emailglobal = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    setEmail();

    const oneHour = Duration(hours: 1);
    const fiveMinutes = Duration(minutes: 3);

    _timer = Timer.periodic(oneHour, (timer) {
      BlocProvider.of<StudentBloc>(context).add(StudentProfileLoadEvent(
        email: emailglobal,
      ));
    });
  }

  int _selectedIndex = 0;

  void _toggleAttendance() {
    setState(() {
      _isPresent = !_isPresent;
      _score = _isPresent ? 10 : 0;
    });
  }

  double calculateRemainingHeight(
      BoxConstraints constraints, double occupiedHeight) {
    double remainingHeight = constraints.maxHeight - occupiedHeight;
    return remainingHeight;
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: fetchLocalUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocConsumer<StudentBloc, StudentState>(
                listener: (context, state) {
              if (state is StudentProfileLoadingState) {
                BlocProvider.of<StudentBloc>(context).add(
                    StudentProfileLoadEvent(
                        email: snapshot.data!.student.email));
              }
            }, builder: (context, state) {
              if (state is StudentProfileLoadingState) {
                BlocProvider.of<StudentBloc>(context).add(
                    StudentProfileLoadEvent(
                        email: snapshot.data!.student.email));
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              else  if (state is StudentScoreLoadingState) {
                    // BlocProvider.of<StudentBloc>(context).add(
                    //     StudentProfileLoadEvent(
                    //         email: snapshot.data!.student.email));
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } 
              else if (state is StudentProfileLoadSuccess) {
                return Scaffold(
                  // appBar: AppBar(
                  //   title: Text(
                  //     'Student Profile',
                  //     style: GoogleFonts.poppins(
                  //       color: Colors.white,
                  //       fontSize: 25,
                  //     ),
                  //   ),
                  //   automaticallyImplyLeading:
                  //       false, // Set to false to remove the back button
                  //   toolbarHeight: 45,
                  //   backgroundColor: Color.fromARGB(255, 36, 36, 37),
                  //   actions: [
                  //     IconButton(
                  //       icon: Icon(Icons.logout),
                  //       onPressed: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return AlertDialog(
                  //               title: Text('Logout'),
                  //               content:
                  //                   Text('Are you sure you want to logout?'),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () {},
                  //                   child: Text('Cancel'),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     BlocProvider.of<LoginBloc>(context).add(
                  //                         LogOutButtonPressed(
                  //                             role:
                  //                                 snapshot.data!.student.role));

                  //                     GoRouter.of(context).push("/login");
                  //                   },
                  //                   child: Text('Logout'),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  body: Container(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          // ignore: prefer_const_constructors
                          Color.fromARGB(
                              255, 51, 49, 65), // Darker color on the left side
                          Color.fromARGB(
                              255, 0, 2, 7), // Lighter color on the right side
                        ],
                      ),
                    ),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      double occupiedHeight =
                          250; // Height of the first container

                      // Calculate the remaining height
                      double remainingHeight =
                          calculateRemainingHeight(constraints, occupiedHeight);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: occupiedHeight,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 8, top: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Logout'),
                                                content: Text(
                                                    'Are you sure you want to logout?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  LoginBloc>(
                                                              context)
                                                          .add(
                                                              LogOutButtonPressed(
                                                                  role: snapshot
                                                                      .data!
                                                                      .student
                                                                      .role));

                                                      GoRouter.of(context)
                                                          .push("/login");
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
                                SizedBox(height: 20),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(state.student.avatar),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  state.student.fullName,
                                  style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 23,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book,
                                      color: Color.fromARGB(255, 64, 155, 95),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      state.student.surah_name,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Ayah ${state.student.ayah_number.toString()}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                              height: remainingHeight,
                              // ignore: prefer_const_constructors
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                                // ignore: prefer_const_constructors
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    // ignore: prefer_const_constructors
                                    Color.fromARGB(255, 18, 3,
                                        27), // Darker color on the left side
                                    Color.fromARGB(255, 37, 36,
                                        43), // Lighter color on the right side
                                  ],
                                ),
                              ),
                              child: state.student.isSaved
                                  ? Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: size.width,
                                          ),
                                          SizedBox(height: 40),
                                          state.student.isPresent
                                              ? Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.green,
                                                        size: 60,
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'Present',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.green,
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'Score: ${snapshot.data!.student.score}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          letterSpacing: 1.2,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 2,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    // color: Color.fromARGB(255, 33, 37, 46),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 60,
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'Absent',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.red,
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        "Your child didn't attend today's class. ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          letterSpacing: 1.2,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 2,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [SizedBox(height: 3)],
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(40),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: size.width,
                                          ),
                                          Card(
                                            color:
                                                Color.fromARGB(255, 40, 39, 49),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.orange,
                                                    size: 50,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    "Attendance has not been taken yet. Please check back later.",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                        ],
                      );
                    }),
                  ),
                  bottomNavigationBar: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 0.1,
                        color: Colors.grey[300], // set the color of the line
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
                                    GoRouter.of(context)
                                        .push("/studentprofile");
                                    break;
                                  case 1:
                                    BlocProvider.of<StudentBloc>(context).add(
                                        StudentAbscentLoadEvent(
                                            id: snapshot.data!.student.id));

                                    GoRouter.of(context).push("/abscentscreen");
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
                          color: true ? Colors.white : const Color(0xff1D1617),
                          fontSize: size.height * 0.015,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return StudentErrorPage();
              }
            });
          } else {
            return const StudentErrorPage();
          }
        });
  }
}
