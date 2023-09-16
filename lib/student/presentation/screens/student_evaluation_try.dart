import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../ustaz/blocs/ustaz_bloc/ustaz_bloc.dart';
import '../../../ustaz/blocs/ustaz_bloc/ustaz_event.dart';
import '../../../ustaz/blocs/ustaz_bloc/ustaz_state.dart';
import '../../../ustaz/ustaz_data_provider/ustaz_data_provider.dart';
import '../../../ustaz/ustaz_repository/ustaz_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/login_details.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../models/student.dart';
import '../components/list_of_surah.dart';
import '../components/student_search_delegate.dart';

class WhiteScreen extends StatelessWidget {
  final List<Student> students_fetched;

  WhiteScreen(this.students_fetched);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StudentList(students_fetched));
  }
}

class StudentList extends StatefulWidget {
  List<Student> students_fetched;

  StudentList(this.students_fetched);
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  // final List<Student> students = [
  //   Student(name: 'John Doe', avatarUrl: 'https://example.com/avatar1.png'),
  //   Student(name: 'Jane Doe', avatarUrl: 'https://example.com/avatar2.png'),
  //   Student(name: 'Bob Smith', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'Abdulmelik Ambaw', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(name: 'Sheik Shemsu', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(name: 'Khalid Abdu', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(name: 'Amir Ahmedin', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(name: 'Temame', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'Abubeker Ibn Osman',
  //       avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'Umer Ibn Khetab', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'osman bin Affan', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'Aliy bin Abi talib',
  //       avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'Seid Ibn Muaz', avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(
  //       name: 'Ihteze Lehu Arshu',
  //       avatarUrl: 'https://example.com/avatar3.png'),
  //   Student(name: 'Ibadellah', avatarUrl: 'https://example.com/avatar3.png'),
  // ];

  // late StreamSubscription<QuerySnapshot> _subscription;
  // late int _unmarkedStudents;

  late UstazRepository _ustazRepository;
  late UstazBloc _bloc;
  late Timer _timer;
  String? currentDate = '';
  // ignore: prefer_final_fields
  int _savingIndex = -1;

  Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void startDailyTask(List<Student> students) async {
    var time = Time(0, 1, 0); // 00:01
    var now = tz.TZDateTime.now(
        tz.local); // Get the current time in the local timezone
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute); // Create a TZDateTime object for 00:01 today
    var scheduledDateTomorrow = scheduledDate.add(
        Duration(days: 1)); // Create a TZDateTime object for 00:01 tomorrow

    // Wait until the scheduled time (00:01) to update the isSaved field
    await Future.delayed(scheduledDate.difference(now));

    for (var student in students) {
      student.isPresent = false;
      student.isSaved = false;
    }
    _bloc.add(NewDayEvent(
      students: students,
    ));

    // Schedule the next update for 00:01 tomorrow
    await Future.delayed(scheduledDateTomorrow.difference(now));
    startDailyTask(
        students); // Recursively call the function to schedule the next update
  }

  @override
  void initState() {
    super.initState();
    _ustazRepository = UstazRepository(ustazdataProvider: UstazDataProvider());
    _bloc = UstazBloc(ustazRepository: _ustazRepository);

    // _bloc.stream.listen((state) {
    //   if (state is NewDayState) {
    //     setState(() {
    //       widget.students_fetched = state.students;
    //     });
    //   }
    // });

    const sixHours = Duration(hours: 6);
    const fiveMinutes = Duration(minutes: 3);
    _timer = Timer.periodic(sixHours, (timer) {
      BlocProvider.of<UstazBloc>(context).add(EvaluateButtonPressed(
        classId: widget.students_fetched[0].classId,
      ));
    });

    // startDailyTask(widget.students_fetched);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
    _timer.cancel();
  }

  bool isPresent = false;
  // int score = 0;
  // String? startSurah = "Al-Fatiha";
  bool isEditable = true;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Student> students_fetched = widget.students_fetched;
    Size size = MediaQuery.of(context).size;

    var brightness = Brightness.dark;
    bool isDarkMode = brightness == Brightness.dark;
    void navigateToStudent(int index) {
      double itemExtent = 180;
      _scrollController.animateTo(
        index * itemExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                BlocProvider.of<UstazBloc>(context).add(GoBack());
              },
            ),
            backgroundColor: Color.fromARGB(255, 31, 34, 36),
            title: Text(
              'Student List',
              style: GoogleFonts.poppins(
                color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                fontSize: size.height * 0.03,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: StudentSearchDelegate(
                          students_fetched, navigateToStudent),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: size.height * 0.05,
          ),
          height: size.height,
          width: size.width * 1.1,
          decoration: BoxDecoration(
            color: isDarkMode ? Color.fromARGB(255, 31, 34, 36) : Colors.white,
          ),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: students_fetched.length,
            itemBuilder: (BuildContext context, int index) {
              // daycontroller(index, students_fetched);
              // _bloc.stream.listen((state) {
              //   if (state is NewDayState) {
              //     setState(() {
              //       students_fetched = state.students;
              //     });
              //   }
              // });

              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Color.fromARGB(255, 55, 60, 63)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                        leading: CircleAvatar(
                          backgroundImage:  NetworkImage(
                              students_fetched[index].avatar),
                          radius: 25.0, // the radius of the CircleAvatar
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        title: Text(
                          students_fetched[index].fullName,
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff1D1617),
                            fontSize: size.height * 0.03,
                          ),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                students_fetched[index].isPresent =
                                    !students_fetched[index].isPresent;
                              });
                            },
                            child: Icon(
                              students_fetched[index].isPresent
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: students_fetched[index].isPresent
                                  ? Colors.green
                                  : Colors.grey,
                              size: size.height * 0.05,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 16, 16),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Score',
                                    style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0),
                                SizedBox(
                                  width: 45,
                                  height: 44,
                                  child: TextFormField(
                                    initialValue: students_fetched[index]
                                        .score
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        students_fetched[index].score =
                                            int.tryParse(value) ?? 0;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? Color.fromARGB(255, 40, 42, 44)
                                          : Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Surah',
                                      style: GoogleFonts.poppins(
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xff1D1617),
                                        fontSize: size.height * 0.02,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  SizedBox(
                                    width:210,
                                    height: 44,
                                    child: DropdownButtonFormField<String>(
                                      style: GoogleFonts.poppins(
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xff1D1617),
                                        fontSize: size.height * 0.02,
                                      ),
                                      value: students_fetched[index].surah_name,
                                      dropdownColor: isDarkMode
                                          ? Color.fromARGB(255, 40, 42, 44)
                                          : Colors.grey[200],
                                      items: surahList.map((surah) {
                                        return DropdownMenuItem<String>(
                                          value: surah,
                                          child: Text(surah),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          students_fetched[index].surah_name =
                                              value!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        filled: true,
                                        fillColor: isDarkMode
                                            ? Color.fromARGB(255, 40, 42, 44)
                                            : Colors.grey[200],
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Sofha',
                                    style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0),
                                SizedBox(
                                  width: 60,
                                  height: 44,
                                  child: TextFormField(
                                    initialValue: students_fetched[index]
                                        .ayah_number
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        students_fetched[index].ayah_number =
                                            int.tryParse(value) ?? 0;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? Color.fromARGB(255, 40, 42, 44)
                                          : Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: _savingIndex == index
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                child: !students_fetched[index].isSaved
                                    ? Text("Save")
                                    : Text("Undo"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !students_fetched[index]
                                          .isSaved
                                      ? Color.fromARGB(255, 34, 42, 61)
                                      : Color.fromARGB(255, 68, 68,
                                          68), // set the button background color
                                  onPrimary: Colors.white, // set the text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // set the button border radius
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 32),
                                ),
                                onPressed: () {
                                  if (!students_fetched[index].isSaved) {
                                    // do some backend work here to save the data
                                    // show a snackbar to let the user know that the data is saved
                                    students_fetched[index].isSaved = true;
                                    setState(() {
                                      _savingIndex = index;
                                    });
                                    _bloc.add(OnSaveEvent(
                                        student: students_fetched[index],
                                        date: DateTime.now().day.toInt()));

                                    // _bloc.stream.listen((state) {
                                    //   if (state is SaveFailureState) {
                                    //     setState(() {
                                    //       students_fetched[index].isSaved = false;
                                    //     });
                                    //   }
                                    // });

                                    _bloc.stream.listen((state) {
                                      if (state is SaveSuccessState) {
                                        setState(() {
                                          students_fetched[index].isSaved =
                                              true;

                                          students_fetched = state.students;
                                          _savingIndex = -1;
                                        });
                                      } else {
                                        students_fetched[index].isSaved = false;
                                      }
                                    });
                                  } else {
                                    // show a confirmation dialog before undoing the changes
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm undo"),
                                          content: Text(
                                              "Are you sure you want to undo the changes?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Confirm"),
                                              onPressed: () {
                                                // do some backend work here to undo the changes
                                                // show a snackbar to let the user know that the changes are undone

                                                students_fetched[index]
                                                    .isSaved = false;
                                                setState(() {
                                                  _savingIndex = index;
                                                });
                                                _bloc.add(OnUndoEvent(
                                                    student:
                                                        students_fetched[index],
                                                    date: DateTime.now()
                                                        .day
                                                        .toInt()));
                                                // _bloc.stream.listen((state) {
                                                //   if (state is UndoFailureState) {
                                                //     setState(() {
                                                //       students_fetched[index]
                                                //           .isSaved = true;
                                                //     });
                                                //   }
                                                // });

                                                _bloc.stream.listen((state) {
                                                  if (state
                                                      is UndoSuccessState) {
                                                    setState(() {
                                                      students_fetched[index]
                                                          .isSaved = false;
                                                      students_fetched =
                                                          state.students;
                                                      _savingIndex = -1;
                                                    });
                                                  } else {
                                                    students_fetched[index]
                                                        .isSaved = true;
                                                  }
                                                }

                                                    //  backend students model update(issaved)

                                                    );
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
