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

class AdminUstazScreen extends StatefulWidget {
  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<AdminUstazScreen> {
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

  List<Ustaz> _ustazs = [];
  List<String> dropdownValues = [];

  String currentUsername = '';
  String currentpassword = '';

  late UstazRepository _ustazRepository;
  late StudentRepository _studentRepository;
  List<Classs> classList = [];

  List<Ustaz> _searchResults = [];

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

  List<Ustaz> _searchustazs(String query) {
    if (query.isEmpty) {
      return _ustazs;
    }
    return _ustazs
        .where((ustaz) =>
            ustaz.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  getresponse() async {
    var response = await http.post(
        Uri.parse("http://127.0.0.1:3000/student/getallclasses"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: null);

    var classes = jsonDecode(response.body);
    List<Classs> ClassHolder = [];
    for (var Class in classes) {
      Classs student = Classs(
        id: Class["_id"],
        className: Class["className"],
        dateCreated: Class['dateCreated'],
        assignedTeacherId: Class["assignedTeacherId"],
      );
      ClassHolder.add(student);
    }
    print(ClassHolder[0].className);
    setState(() {
      classList = ClassHolder;
    });
    List<String> holder = [];
    for (var Class in classList) {
      holder.add(Class.className);
    }
    setState(() {
      dropdownValues = holder;
    });
    print(dropdownValues);
    return ClassHolder;
  }

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

    getresponse();
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
        _searchResults = _searchustazs(_searchController.text);
      });
    });
  }

  int _selectedIndex = 1;
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
        body: BlocConsumer<AdminUstazBloc, AdminState>(
      listener: (context, state) {
        // if (state is LoginSuccess) {
        //   GoRouter.of(context).pushReplacement("/");
        // } else
        if (state is InitialUstazFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("connection problem"),
            ),
          );
        } else if (state is UstazDeleteOperationSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Account Deleted Successfully'),
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
        else if (state is UstazOperationFailure) {
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
          case AdminUstazLoading:
            BlocProvider.of<AdminUstazBloc>(context).add(InitustazEvent());
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case InitialUstazFailureState:
            return const ErrorBody();
          case UstazAddOperationSuccess:
          case UstazUpdateOperationSuccess:
          case IntialUstazsState:
          case UstazDeleteOperationSuccess:
            if (state is IntialUstazsState) {
              _ustazs = state.ustazs;
            } else if (state is UstazDeleteOperationSuccess) {
              _ustazs = state.ustazs;
            } else if (state is UstazAddOperationSuccess) {
              _ustazs = state.ustazs;
            } else if (state is UstazUpdateOperationSuccess) {
              _ustazs = state.ustazs;
            }
            return MaterialApp(
              home: Container(
                child: Scaffold(
                    body: Container(
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
                                        _searchResults = _ustazs;
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
                                              'No Ustazs found',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: _searchResults.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                leading: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2),
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            _searchResults[
                                                                    index]
                                                                .avatar),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  _searchResults[index]
                                                      .fullName,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                subtitle: Text(
                                                  _searchResults[index].email,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                trailing: IconButton(
                                                    color: Colors.white,
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () => {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Delete Ustaz"),
                                                                content: Text(
                                                                    "Are you sure you want to delete ${_searchResults[index].fullName}"),
                                                                actions: [
                                                                  TextButton(
                                                                    child: Text(
                                                                        "Cancel"),
                                                                    onPressed:
                                                                        () {
                                                                      // Close dialog box
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        "Delete"),
                                                                    onPressed:
                                                                        () {
                                                                      // Delete student and close dialog box
                                                                      BlocProvider.of<AdminUstazBloc>(
                                                                              context)
                                                                          .add(DeleteUstazButtonPressed(
                                                                              email: _searchResults[index].email));
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          )
                                                        }),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return UstazEditProfileBody(
                                                          ustaz: _searchResults[
                                                              index]);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          )
                                    : _ustazs.isEmpty
                                        ? Center(
                                            child: Text(
                                              'No Ustazs found',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(
                                            // decoration: BoxDecoration(color: Color.fromARGB(255, 31, 34, 36)),
                                            child: ListView.builder(
                                              itemCount: _ustazs.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2),
                                                        child: Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  _ustazs[index]
                                                                      .avatar),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        _ustazs[index].fullName,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: true
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xff1D1617),
                                                          fontSize:
                                                              size.height *
                                                                  0.022,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        _ustazs[index].email,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: true
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xff1D1617),
                                                          fontSize:
                                                              size.height *
                                                                  0.012,
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                          color: Colors.white,
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
                                                                      title: Text(
                                                                          "Delete Ustaz"),
                                                                      content: Text(
                                                                          "Are you sure you want to delete ${_ustazs[index].fullName}"),
                                                                      actions: [
                                                                        TextButton(
                                                                          child:
                                                                              Text("Cancel"),
                                                                          onPressed:
                                                                              () {
                                                                            // Close dialog box
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          child:
                                                                              Text("Delete"),
                                                                          onPressed:
                                                                              () {
                                                                            // Delete student and close dialog box
                                                                            BlocProvider.of<AdminUstazBloc>(context).add(DeleteUstazButtonPressed(email: _ustazs[index].email));
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                )
                                                              }),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return UstazEditProfileBody(
                                                                ustaz: _ustazs[
                                                                    index]);
                                                          },
                                                        );
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
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        final nameController = TextEditingController();
                        final _countryController = TextEditingController();
                        final _sexController = TextEditingController();

                        String _selectedkiratTypeValue = "Hifz";
                        String _selectedClassValue = "Bukhari";
                        String _selectedSurahValue = "Al-Fatiha";

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const UstazSIgnUpBody();
                          },
                        );
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

  Widget _buildStudentList() {
    Size size = MediaQuery.of(context).size;

    return Container(
      // decoration: BoxDecoration(color: Color.fromARGB(255, 31, 34, 36)),
      child: ListView.builder(
        itemCount: _ustazs.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            NetworkImage('https://source.unsplash.com/random'),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  _ustazs[index].fullName,
                  style: GoogleFonts.poppins(
                    color: true ? Colors.white : const Color(0xff1D1617),
                    fontSize: size.height * 0.022,
                  ),
                ),
                subtitle: Text(
                  _ustazs[index].email,
                  style: GoogleFonts.poppins(
                    color: true ? Colors.white : const Color(0xff1D1617),
                    fontSize: size.height * 0.012,
                  ),
                ),
                trailing: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.delete),
                  onPressed: () => BlocProvider.of<AdminUstazBloc>(context).add(
                      DeleteButtonPressed(email: _searchResults[index].email)),
                ),
                onTap: () {
                  // _showEditStudentDialog(context, _students[index], index);
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
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Padding(
            padding: EdgeInsets.only(top: 2),
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('https://source.unsplash.com/random'),
                ),
              ),
            ),
          ),
          title: Text(
            _searchResults[index].fullName,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            _searchResults[index].email,
            style: TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            color: Colors.white,
            icon: Icon(Icons.delete),
            onPressed: () => BlocProvider.of<AdminUstazBloc>(context)
                .add(DeleteButtonPressed(email: _searchResults[index].email)),
          ),
          onTap: () {
            // _showEditStudentDialog(context, _searchResults[index],
            //     _students.indexOf(_searchResults[index]));
          },
        );
      },
    );
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
    final _countryController = TextEditingController();
    final _sexController = TextEditingController();

    String _selectedkiratTypeValue = "Hifz";
    String _selectedClassValue = "Bukhari";
    String _selectedSurahValue = "Al-Fatiha";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedkiratTypeValue,
                decoration: InputDecoration(
                  labelText: 'Kirat Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _selectedkiratTypeValue = value!;
                },
                items: [
                  DropdownMenuItem(
                    value: 'Hifz',
                    child: Text('Hifz'),
                  ),
                  DropdownMenuItem(
                    value: 'Nezor',
                    child: Text('Nezor'),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedClassValue,
                decoration: InputDecoration(
                  labelText: 'Select Class',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _selectedClassValue = value!;
                },
                items: dropdownValues.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'country',
                ),
              ),
              TextField(
                controller: _sexController,
                decoration: InputDecoration(
                  labelText: 'Sex',
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedSurahValue,
                decoration: InputDecoration(
                  labelText: 'Surah Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedSurahValue = value!;
                  });
                },
                items: surahList.map((surah) {
                  return DropdownMenuItem<String>(
                    value: surah,
                    child: Text(surah),
                  );
                }).toList(),
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
                final className = _selectedClassValue;

                Classs? matchingClass = classList.firstWhere(
                  (c) => c.className == className,
                );

                Map<String, String> credentials =
                    await generateUserCredentials();
                String? username = credentials["username"];
                String? password = credentials["password"];
                setState(() {
                  currentUsername = username!;
                  currentpassword = password!;
                });
                final name = nameController.text;
                final kirattype = _selectedkiratTypeValue;
                final country = _countryController.text;
                final sex = _sexController.text;
                final surahName = _selectedSurahValue;
                final String classId = matchingClass.id;

                if (name.isNotEmpty &&
                    kirattype.isNotEmpty &&
                    country.isNotEmpty &&
                    sex.isNotEmpty &&
                    surahName.isNotEmpty &&
                    className.isNotEmpty) {
                  // SignUpModel signUpModel = SignUpModel.create(name, username,
                  //     password, kirattype, className, country, sex, surahName);
                  // BlocProvider.of<AdminBloc>(context)
                  //     .add(AddStudentButton(signUpModel: signUpModel));

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

//   void _showEditStudentDialog(
//       BuildContext context, Student student, int index) {
//     final nameController =
//         TextEditingController(text: _students[index].fullName);
//     final _countryController =
//         TextEditingController(text: _students[index].country);
//     final _sexController = TextEditingController(text: _students[index].sex);

//     String _selectedkiratTypeValue = _students[index].kirat_type;
//     String _selectedClassValue = "Bukhari";
//     String _selectedSurahValue = _students[index].surah_name;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Student'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                 ),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedkiratTypeValue,
//                 decoration: InputDecoration(
//                   labelText: 'Kirat Type',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedkiratTypeValue = value!;
//                   });
//                 },
//                 items: [
//                   DropdownMenuItem(
//                     value: 'Hifz',
//                     child: Text('Hifz'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Nezor',
//                     child: Text('Nezor'),
//                   ),
//                 ],
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedClassValue,
//                 decoration: InputDecoration(
//                   labelText: 'Select Class',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedClassValue = value!;
//                   });
//                 },
//                 items: dropdownValues.map((value) {
//                   return DropdownMenuItem(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               TextField(
//                 controller: _countryController,
//                 decoration: InputDecoration(
//                   labelText: 'country',
//                 ),
//               ),
//               TextField(
//                 controller: _sexController,
//                 decoration: InputDecoration(
//                   labelText: 'Sex',
//                 ),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedSurahValue,
//                 decoration: InputDecoration(
//                   labelText: 'Surah Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedSurahValue = value!;
//                   });
//                 },
//                 items: surahList.map((surah) {
//                   return DropdownMenuItem<String>(
//                     value: surah,
//                     child: Text(surah),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Save'),
//               onPressed: () {
//                 var className = _selectedClassValue;

//                 Classs? matchingClass = classList.firstWhere(
//                   (c) => c.className == className,
//                 );

//                 final name = nameController.text;
//                 final kirattype = _selectedkiratTypeValue;
//                 final country = _countryController.text;
//                 final sex = _sexController.text;
//                 final surahName = _selectedSurahValue;
//                 final String classId = matchingClass.id;
//                 _students[index].fullName = name;

//                 _students[index].fullName = name;
//                 _students[index].kirat_type = kirattype;
//                 _students[index].country = country;
//                 _students[index].sex = sex;
//                 _students[index].surah_name = surahName;
//                 _students[index].classId = className;

//                 if (name.isNotEmpty &&
//                     kirattype.isNotEmpty &&
//                     country.isNotEmpty &&
//                     sex.isNotEmpty &&
//                     surahName.isNotEmpty &&
//                     classId.isNotEmpty) {
//                   BlocProvider.of<AdminBloc>(context)
//                       .add(UpdateStudentButton(student: _students[index]));

//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
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
            BlocProvider.of<AdminUstazBloc>(context).add(InitustazEvent());
          },
        ),
      ),
    );
  }
}
