import 'dart:convert';
import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/blocs.dart';
import 'package:online_quran_frontend/student/models/signup_model.dart';

import '../../../admin/blocs/admin_class_bloc.dart';
import '../../../admin/blocs/admin_student_bloc.dart';
import '../../../admin/blocs/admin_event.dart';
import '../../../admin/blocs/admin_state.dart';
import '../../../admin/blocs/admin_ustaz_bloc.dart';
import '../../../admin/class_model.dart';
import '../../../ustaz/models/ustaz_model.dart';
import '../../../ustaz/ustaz_data_provider/ustaz_data_provider.dart';
import '../../../ustaz/ustaz_repository/ustaz_repository.dart';
import '../../data_providers/student_data_provider.dart';
import '../../models/student.dart';
import '../../repository/student_repository.dart';
import '../components/edit_profile_body.dart';
import '../components/list_of_surah.dart';
import '../components/signup_body.dart';
import '../components/ustaz_edit_profile.dart';
import '../components/ustaz_signup_body.dart';

// class Student {
//   final int id;
//   final String name;
//   final String email;

//   const Student({required this.id, required this.name, required this.email});
// }

class AdminClassScreen extends StatefulWidget {
  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<AdminClassScreen> {
  // List<Student> _students = [
  //   Student(id: 1, name: 'John Doe', email: 'johndoe@example.com'),
  //   Student(id: 2, name: 'Jane Doe', email: 'janedoe@example.com'),
  //   Student(id: 4, name: 'Bob Smith', email: 'bobsmith@example.com'),
  //   Student(id: 5, name: 'Kalima Smith', email: 'bobsmith@example.com'),
  //   Student(id: 6, name: 'Sarima Arebu', email: 'bobsmith@example.com'),
  //   Student(id: 7, name: 'Kutmers Smith', email: 'bobsmith@example.com'),
  //   Student(id: 8, name: 'Aremade Awesa', email: 'bobsmith@example.com'),
  //   Student(id: 9, name: 'ERRE Smith', email: 'bobsmith@example.com'),
  //   Student(id: 10, name: 'Bob Smith', email: 'bobsmith@example.com'),
  //   Student(id: 11, name: 'Bob Smith', email: 'bobsmith@example.com'),
  // ];

  List<Classs> classes = [];
  List<String> dropdownValues = [];

  late UstazRepository _ustazRepository;
  late StudentRepository _studentRepository;

  List<Classs> _searchResults = [];

  final _searchController = TextEditingController();

  bool _isSearching = false;

  // void _addStudent(Ustaz ustaz) {
  //   setState(() {
  //     _ustazs.add(student);
  //   });
  // }

  final Color backgroundColor = Color.fromARGB(255, 31, 34, 36);

  // void _editStudent(int index, Student student) {
  //   setState(() {
  //     _students[index] = student;
  //   });
  //   _searchResults = _searchStudents(_searchController.text);
  // }

  // void _deleteStudent(int index) {
  //   setState(() {
  //     _students.removeAt(index);
  //   });
  //   _searchResults = _searchStudents(_searchController.text);
  // }

  List<Classs> _searchclasses(String query) {
    if (query.isEmpty) {
      return classes;
    }
    return classes
        .where((classs) =>
            classs.className.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // getresponse() async {
  //   var response = await http.post(
  //       Uri.parse("http://127.0.0.1:3000/student/getallclasses"),
  //       headers: <String, String>{"Content-Type": "application/json"},
  //       body: null);

  //   var classes = jsonDecode(response.body);
  //   List<Classs> ClassHolder = [];
  //   for (var Class in classes) {
  //     Classs student = Classs(
  //       id: Class["_id"],
  //       className: Class["className"],
  //       dateCreated: Class['dateCreated'],
  //       assignedTeacherId: Class["assignedTeacherId"],
  //     );
  //     ClassHolder.add(student);
  //   }
  //   print(ClassHolder[0].className);
  //   setState(() {
  //     classList = ClassHolder;
  //   });
  //   List<String> holder = [];
  //   for (var Class in classList) {
  //     holder.add(Class.className);
  //   }
  //   setState(() {
  //     dropdownValues = holder;
  //   });
  //   print(dropdownValues);
  //   return ClassHolder;
  // }

  @override
  initState() {
    super.initState();
    _ustazRepository = UstazRepository(ustazdataProvider: UstazDataProvider());
    _studentRepository = StudentRepository(dataProvider: StudentDataProvider());

    // _bloc.stream.listen((state) {
    //   if (state is AdminScreenLoading) {
    //     _bloc.add(InitstudentsEvent());
    //   }

    // });

    // final classes = response;
    // List<Classs> ClassHolder = [];
    // for (var Class in classes) {
    //   Classs student = Classs(
    //     id: Class["_id"],
    //     className: Class["className"],
    //     dateCreated: Class['dateCreated'],
    //     assignedTeacherId: Class["assignedTeacherId"],
    //   );
    //   ClassHolder.add(student);
    // }

    // List<String> holder = [];
    // for (var Class in classList) {
    //   holder.add(Class.className);
    // }
    // setState(() {
    //   dropdownValues = holder;
    // });
    _searchController.addListener(() {
      setState(() {
        _searchResults = _searchclasses(_searchController.text);
      });
    });
  }

  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).push("/managestudent");

        break;
      case 1:
        GoRouter.of(context).push("/manageustaz");

        break;
      case 2:
        GoRouter.of(context).push("/manageclass");

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = true;

    return Scaffold(
        body: BlocConsumer<AdminClassBloc, AdminState>(
      listener: (context, state) {
        // if (state is LoginSuccess) {
        //   GoRouter.of(context).pushReplacement("/");
        // } else
        if (state is InitialClassFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("connection problem"),
            ),
          );
        } else if (state is ClassDeleteOperationSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Class Deleted Successfully'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        // else if (state is StudentAddOperationSuccess) {
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text('Account Created Successfully'),
        //         content: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text('Username: $currentUsername'),
        //             Text('Password: $currentpassword'),
        //           ],
        //         ),
        //         actions: [
        //           TextButton(
        //             child: Text('OK'),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }
        else if (state is ClassOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Unable to do the opration"),
            ),
          );
        }
      },
      builder: (context, state) {
        print("here is it: ${state.runtimeType}");
        switch (state.runtimeType) {
          case AdminClassLoading:
            BlocProvider.of<AdminClassBloc>(context).add(InitclassesEvent());
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case InitialClassFailureState:
            return const ErrorBody();
          case StudentOperationProgress:
          case ClassAddOperationSuccess:
          case classUpdateOperationSuccess:
          case IntialClassessState:
          case ClassDeleteOperationSuccess:
            if (state is IntialClassessState) {
              classes = state.classes;
            } else if (state is ClassDeleteOperationSuccess) {
              classes = state.classes;
            } else if (state is ClassAddOperationSuccess) {
              classes = state.classes;
            } else if (state is classUpdateOperationSuccess) {
              classes = state.classes;
            }
            return MaterialApp(
              home: Container(
                child: Scaffold(
                    body: Stack(
                      children: [
                        Container(
                          height: size.height,
                          width: size.width * 1.1,
                          decoration: BoxDecoration(color: Color(0xFF1a1d22)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            _isSearching = false;
                                            _searchController.clear();
                                            _searchResults = classes;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: GoogleFonts.poppins(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff1D1617),
                                            fontSize: size.height * 0.025,
                                          ),
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: 'Search...',
                                            hintStyle: GoogleFonts.poppins(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : const Color(0xff1D1617),
                                              fontSize: size.height * 0.025,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _isSearching = true;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.clear),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: 16),
                                  Expanded(
                                    child: _isSearching
                                        ? _searchResults.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No classes found',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount:
                                                    _searchResults.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                      _searchResults[index]
                                                          .className,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    trailing: IconButton(
                                                        color: Colors.white,
                                                        icon:
                                                            Icon(Icons.delete),
                                                        onPressed: () => {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Delete Class"),
                                                                    content: Text(
                                                                        "Are you sure you want to delete ${_searchResults[index].className}"),
                                                                    actions: [
                                                                      TextButton(
                                                                        child: Text(
                                                                            "Cancel"),
                                                                        onPressed:
                                                                            () {
                                                                          // Close dialog box
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text(
                                                                            "Delete"),
                                                                        onPressed:
                                                                            () {
                                                                          // Delete student and close dialog box
                                                                          BlocProvider.of<AdminClassBloc>(context)
                                                                              .add(DeleteClassButtonPressed(id: _searchResults[index].className));
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              )
                                                            }),
                                                    onTap: () {
                                                      _showEditStudentDialog(
                                                          context,
                                                          _searchResults[index],
                                                          index);
                                                    },
                                                  );
                                                },
                                              )
                                        : classes.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No classes found',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(
                                                // decoration: BoxDecoration(color: Color.fromARGB(255, 31, 34, 36)),
                                                child: ListView.builder(
                                                  itemCount: classes.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                            classes[index]
                                                                .className,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: true
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xff1D1617),
                                                              fontSize:
                                                                  size.height *
                                                                      0.022,
                                                            ),
                                                          ),
                                                          trailing: IconButton(
                                                              color:
                                                                  Colors.white,
                                                              icon: Icon(
                                                                  Icons.delete),
                                                              onPressed: () => {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text("Delete Class"),
                                                                          content:
                                                                              Text("Are you sure you want to delete ${classes[index].className}"),
                                                                          actions: [
                                                                            TextButton(
                                                                              child: Text("Cancel"),
                                                                              onPressed: () {
                                                                                // Close dialog box
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              child: Text("Delete"),
                                                                              onPressed: () {
                                                                                // Delete student and close dialog box
                                                                                BlocProvider.of<AdminClassBloc>(context).add(DeleteClassButtonPressed(id: classes[index].className));
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    )
                                                                  }),
                                                          onTap: () {
                                                            _showEditStudentDialog(
                                                                context,
                                                                classes[index],
                                                                index);
                                                          },
                                                        ),
                                                        Container(
                                                          height: 0.3,
                                                          color: Colors.white,
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
                        if (state is StudentOperationProgress)
                          Positioned.fill(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        _showAddStudentDialog(context);
                      },
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
                                Icons.people,
                              ),
                              label: 'Students',
                            ),
                            BottomNavigationBarItem(
                              backgroundColor: Colors.white,
                              icon: Icon(
                                Icons.supervised_user_circle,
                              ),
                              label: 'Teachers',
                            ),
                            BottomNavigationBarItem(
                              backgroundColor: Colors.white,
                              icon: Icon(
                                Icons.class_,
                              ),
                              label: 'Classes',
                            ),
                          ],
                          currentIndex: _selectedIndex,
                          onTap: _onItemTapped,
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: Colors.blue,
                          selectedIconTheme: IconThemeData(
                            color: Colors.blue,
                          ),
                          unselectedItemColor: Colors.white,
                          unselectedLabelStyle: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff1D1617),
                            fontSize: size.height * 0.015,
                          ),
                        ),
                      ],
                    )),
              ),
            );

          default:
            return const ErrorBody();
        }
      },
    ));
  }

  Future<Map<String, String>> generateUserCredentials() async {
    String generateRandomString(int length) {
      var random = Random.secure();
      var values = List<int>.generate(length, (i) => random.nextInt(255));
      return base64Url.encode(values);
    }

    String username = generateRandomString(8);
    String password = generateRandomString(8);

    var response =
        await http.post(Uri.parse("http://127.0.0.1:3000/student/getStudent"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "email": username,
            }));
    var condition = jsonDecode(response.body)["_id"];
    while (condition) {
      username = generateRandomString(8);
      response =
          await http.post(Uri.parse("http://127.0.0.1:3000/student/getStudent"),
              headers: <String, String>{"Content-Type": "application/json"},
              body: jsonEncode({
                "email": username,
              }));
    }

    return {"username": username, "password": password};
  }

  void _showAddStudentDialog(BuildContext context) async {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Class Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // ignore: no_leading_underscores_for_local_identifiers
                String _twoDigitString(int number) {
                  return number.toString().padLeft(2, '0');
                }

                final name = nameController.text;
                DateTime now = DateTime.now();
                String date =
                    "${now.year}-${_twoDigitString(now.month)}-${_twoDigitString(now.day)}";

                if (name.isNotEmpty) {
                  BlocProvider.of<AdminClassBloc>(context).add(AddClassButton(
                      className: name,
                      dateCreated: date,
                      assignedTeacherId: "no one"));

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditStudentDialog(BuildContext context, Classs classs, int index) {
    final nameController = TextEditingController(text: classs.className);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Class Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final name = nameController.text;

                if (name.isNotEmpty) {
                  setState(() {
                    classs.id = name;
                  });

                  BlocProvider.of<AdminClassBloc>(context)
                      .add(UpdateclassButton(classs: classs));

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ErrorBody extends StatefulWidget {
  const ErrorBody({Key? key}) : super(key: key);

  @override
  ErrorState createState() => ErrorState();
}

class ErrorState extends State<ErrorBody> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Error Occurred. Go back"),
          onPressed: () {
            BlocProvider.of<AdminClassBloc>(context).add(InitclassesEvent());
          },
        ),
      ),
    );
  }
}
