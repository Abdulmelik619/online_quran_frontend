import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../admin/blocs/admin_student_bloc.dart';
import '../../../admin/blocs/admin_event.dart';
import '../../../admin/blocs/admin_state.dart';
import '../../../admin/blocs/admin_ustaz_bloc.dart';
import '../../../admin/class_model.dart';
import '../../../ustaz/models/ustaz_model.dart';
import '../../../ustaz/ustaz_data_provider/ustaz_data_provider.dart';
import '../../../ustaz/ustaz_repository/ustaz_repository.dart';
import '../../blocs/student_bloc/signup_bloc.dart';
import '../../blocs/student_bloc/student_event.dart';
import '../../data_providers/student_data_provider.dart';
import '../../models/signup_model.dart';
import '../../models/student.dart';
import '../../repository/student_repository.dart';

class UstazEditProfileBody extends StatefulWidget {
  final Ustaz ustaz;
  const UstazEditProfileBody({Key? key, required this.ustaz}) : super(key: key);

  @override
  State<UstazEditProfileBody> createState() => SignUpState();
}

class SignUpState extends State<UstazEditProfileBody> {
  List<Classs> classList = [];

  List<String> dropdownValues = [];

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  var _fullnamekey = GlobalKey<FormFieldState<String>>();
  var _kirattypekey = GlobalKey<FormFieldState<String>>();
  var _countryKey = GlobalKey<FormFieldState<String>>();
  var _sexKey = GlobalKey<FormFieldState<String>>();
  var _classNameKey = GlobalKey<FormFieldState<String>>();
  var _fortrykey = GlobalKey<FormFieldState<String>>();

  TextEditingController _fortrycontroller = TextEditingController();
  TextEditingController _fullnamecontroller = TextEditingController();
  TextEditingController _countrycontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  static String _fullName = "";
  static String _country = "";
  static String _password = "";
  static String _className = "";
  static String _sex = "";
  static String _kirat_type = "";
  static String _surah_name = "";
  static String _ayah_number = "";
  static String _role = "";
  bool pwVisible = false;
  static String _fortry = "";
  static String sexerror = "";
  static String classNameError = "";
  static String nameErorr = "";
  static String countryError = "";
  static String kirattypeerror = "";

  bool _isChecked = false;

  String currentUsername = '';
  String currentpassword = '';

  final brightness = Brightness.dark;

  Color _nameborderColor = true ? const Color(0xff151f2c) : Colors.white;
  Color _countryborderColor = true ? const Color(0xff151f2c) : Colors.white;
  Color _sexborderColor = true ? const Color(0xff151f2c) : Colors.white;
  Color _classNameborderColor = Color(0xff7B6F72);
  Color _kirattypeborderColor = Color(0xff7B6F72);

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
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

  // late AdminBloc _bloc;
  @override
  initState() {
    super.initState();
    getresponse();
    // final StudentRepository studentRepository =
    //     StudentRepository(dataProvider: StudentDataProvider());
    // final UstazRepository ustazRepository =
    //     UstazRepository(ustazdataProvider: UstazDataProvider());
    // _bloc = AdminBloc(
    //     studentRepository: studentRepository, ustazRepository: ustazRepository);

    _fullnamecontroller = TextEditingController(text: widget.ustaz.fullName);
  }

  Future<Map<String, String>> generateUserCredentials() async {
    String generateRandomString(int length) {
      var random = Random.secure();
      var codeUnits = List.generate(
        length,
        (index) => random.nextInt(26) + 97,
      );
      return String.fromCharCodes(codeUnits);
    }

    String username = generateRandomString(6);
    String password = generateRandomString(4);

    var response =
        await http.post(Uri.parse("http://127.0.0.1:3000/ustaz/getustaz"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "email": username,
            }));
    while (response.body.length != 0) {
      username = generateRandomString(8);
      response =
          await http.post(Uri.parse("http://127.0.0.1:3000/ustaz/getustaz"),
              headers: <String, String>{"Content-Type": "application/json"},
              body: jsonEncode({
                "email": username,
              }));
    }

    return {"username": username, "password": password};
  }

  String? _avatarImageUrl = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = true;

    return BlocConsumer<AdminUstazBloc, AdminState>(listener: (context, state) {
      // if (state is LoginSuccess) {
      //   GoRouter.of(context).pushReplacement("/");
      // } else

      if (state is UstazUpdateOperationSuccess) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Account Updated Successfully'),
              content: _isChecked
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: $currentUsername'),
                        Text('Password: $currentpassword'),
                      ],
                    )
                  : SizedBox(width: 0, height: 0),
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
      } else if (state is ImageAddSuccess) {
        _avatarImageUrl = state.avatar;
      }
    }, builder: (context, state) {
      return MaterialApp(
        scaffoldMessengerKey: scaffoldKey,
        home: Scaffold(
          // key: scaffoldKey,
          body: Center(
            child: Container(
              height: size.height,
              width: size.width * 1.1,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
              ),
              child: SafeArea(
                  child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(width: size.width * 0.3),
                              Text(
                                'Hey there,',
                                style: GoogleFonts.poppins(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xff1D1617),
                                  fontSize: size.height * 0.022,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.001),
                          child: Align(
                              child: Text(
                            'Edit an Account',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff1D1617),
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: size.height * 0.025),
                            child: Container(
                              width: size.width * 0.9,
                              // height: size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: _nameborderColor,
                                  // width: 1.0,
                                ),
                              ),
                              child: Form(
                                child: TextFormField(
                                  key: _fullnamekey,
                                  controller: _fullnamecontroller,
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? const Color(0xffADA4A5)
                                          : Colors.black),
                                  obscureText: false ? !pwVisible : false,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0,
                                    ),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.005,
                                      ),
                                      child: Icon(
                                        Icons.person_outlined,
                                        color: const Color(0xff7B6F72),
                                      ),
                                    ),
                                    hintText: 'Full Name',
                                    hintStyle: TextStyle(
                                      color: isDarkMode
                                          ? const Color(0xffADA4A5)
                                          : Colors.black,
                                    ),
                                    filled: true,
                                    fillColor: isDarkMode
                                        ? Colors.black
                                        : const Color(0xffF7F8F8),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                        color: isDarkMode
                                            ? Colors.black
                                            : const Color(0xffF7F8F8),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onSaved: (newValue) {
                                    setState(() {
                                      _fullName = newValue!;
                                    });
                                  },
                                  // validator: (value) {
                                  //   int? length = value!.length;
                                  //   if (length <= 2) {
                                  //     return "";
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            )),
                        nameErorr != ""
                            ? Text(
                                nameErorr,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),

                        // Padding(
                        //     padding: EdgeInsets.only(top: size.height * 0.025),
                        //     child: Container(
                        //       width: size.width * 0.9,
                        //       // height: size.height * 0.07,
                        //       decoration: BoxDecoration(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(15)),
                        //         border: Border.all(
                        //           color: _passwordborderColor,
                        //           width: 1.0,
                        //         ),
                        //       ),
                        //       child: Form(
                        //         child: TextFormField(
                        //           key: _passwordKey,
                        //           controller: _passwordcontroller,
                        //           style: TextStyle(
                        //               color: isDarkMode
                        //                   ? const Color(0xffADA4A5)
                        //                   : Colors.black),
                        //           obscureText: true ? !pwVisible : false,
                        //           textInputAction: TextInputAction.next,
                        //           decoration: InputDecoration(
                        //             contentPadding: EdgeInsets.symmetric(
                        //               vertical: 0.0,
                        //             ),
                        //             prefixIcon: Padding(
                        //               padding: EdgeInsets.only(
                        //                 top: size.height * 0.005,
                        //               ),
                        //               child: Icon(
                        //                 Icons.lock_outlined,
                        //                 color: const Color(0xff7B6F72),
                        //               ),
                        //             ),
                        //             suffixIcon: true
                        //                 ? Padding(
                        //                     padding: EdgeInsets.only(
                        //                       top: size.height * 0.005,
                        //                     ),
                        //                     child: InkWell(
                        //                       onTap: () {
                        //                         setState(() {
                        //                           pwVisible = !pwVisible;
                        //                         });
                        //                       },
                        //                       child: pwVisible
                        //                           ? const Icon(
                        //                               Icons
                        //                                   .visibility_off_outlined,
                        //                               color: Color(0xff7B6F72),
                        //                             )
                        //                           : const Icon(
                        //                               Icons.visibility_outlined,
                        //                               color: Color(0xff7B6F72),
                        //                             ),
                        //                     ),
                        //                   )
                        //                 : null,
                        //             hintText: 'Password',
                        //             hintStyle: TextStyle(
                        //               color: isDarkMode
                        //                   ? const Color(0xffADA4A5)
                        //                   : Colors.black,
                        //             ),
                        //             filled: true,
                        //             fillColor: isDarkMode
                        //                 ? Colors.black
                        //                 : const Color(0xffF7F8F8),
                        //             border: OutlineInputBorder(
                        //               borderRadius:
                        //                   BorderRadius.all(Radius.circular(15)),
                        //               borderSide: BorderSide(
                        //                 color: isDarkMode
                        //                     ? Colors.black
                        //                     : const Color(0xffF7F8F8),
                        //                 width: 1.0,
                        //               ),
                        //             ),
                        //           ),
                        //           onSaved: (newValue) {
                        //             setState(() {
                        //               _password = newValue!;
                        //             });
                        //           },
                        //           // validator: (value) {
                        //           //   int? length = value!.length;
                        //           //   if (length <= 2) {
                        //           //     return "";
                        //           //   }
                        //           //   return null;
                        //           // },
                        //         ),
                        //       ),
                        //     )),
                        // passworderror != ""
                        //     ? Text(
                        //         passworderror,
                        //         style: TextStyle(
                        //           color: Colors.red,
                        //         ),
                        //       )
                        //     : SizedBox(
                        //         height: 0,
                        //         width: 0,
                        //       ),

                        Padding(
                            padding: EdgeInsets.only(top: size.height * 0.025),
                            child: Container(
                              width: size.width * 0.6,
                              // height: size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: _classNameborderColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Form(
                                key: _formKey2,
                                child: DropdownButtonFormField(
                                  itemHeight: 48.0,
                                  dropdownColor: true
                                      ? const Color(0xff1C1C1C)
                                      : Colors.white,
                                  key: _classNameKey,
                                  // controller: _confirmpasswordcontroller,
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? const Color(0xffADA4A5)
                                          : Colors.black),
                                  // obscureText: true ? !pwVisible : false,
                                  // textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0,
                                    ),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.005,
                                      ),
                                      child: Icon(
                                        Icons.book_online_rounded,
                                        color: const Color(0xff7B6F72),
                                      ),
                                    ),
                                    hintText: 'Select Class',
                                    hintStyle: TextStyle(
                                      color: isDarkMode
                                          ? const Color(0xffADA4A5)
                                          : Colors.black,
                                    ),
                                    filled: true,
                                    fillColor: isDarkMode
                                        ? Colors.black
                                        : const Color(0xffF7F8F8),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                        color: isDarkMode
                                            ? Colors.black
                                            : const Color(0xffF7F8F8),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _className = newValue!;
                                    });
                                  },
                                  items: dropdownValues.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  // validator: (value) {
                                  //   int? length = value!.length;
                                  //   if (length <= 2) {
                                  //     return "";
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            )),
                        classNameError != ""
                            ? Text(
                                classNameError,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                        const SizedBox(height: 20.0),

                        Stack(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                BlocProvider.of<AdminUstazBloc>(context)
                                    .add(AddImage());
                              },
                              icon: Icon(Icons.add_a_photo),
                              label: Text('Choose Avatar'),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 8, 12, 17),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                            if (state is ImageOperationProgress)
                              Positioned.fill(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              size.height * 0.05, size.height * 0.025, 0, 0),
                          child: Row(
                            children: [
                              Checkbox(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                                value: _isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isChecked = newValue!;
                                  });
                                },
                              ),
                              Text(
                                'Forgot password or username?',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            AnimatedPadding(
                                duration: const Duration(milliseconds: 500),
                                padding:
                                    EdgeInsets.only(top: size.height * 0.025),
                                child: ElevatedButton(
                                  child: Text("Update"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode
                                        ? const Color(0xff252525)
                                        : const Color(
                                            0xff92A3FD), // set the button background color
                                    onPrimary:
                                        Colors.white, // set the text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // set the button border radius
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                  ),
                                  onPressed: () async {
                                    //validation for register
                                    if (_fullnamekey
                                            .currentState!.value!.length >
                                        4) {
                                      setState(() {
                                        _fullName =
                                            _fullnamekey.currentState!.value!;
                                        nameErorr = "";
                                        _nameborderColor = true
                                            ? const Color(0xff151f2c)
                                            : Colors.white;
                                      });

                                      // if (_classNameKey.currentState!.value !=
                                      //         null &&
                                      //     _classNameKey.currentState!.value !=
                                      //         "") {
                                      //   // _password =
                                      //   //     _passwordKey.currentState!.value!;
                                      //   setState(() {
                                      //     classNameError = "";
                                      //     _classNameborderColor = true
                                      //         ? const Color(0xff151f2c)
                                      //         : Colors.white;
                                      //   });

                                      // if (_kirattypekey.currentState!.value !=
                                      //         null &&
                                      //     _kirattypekey.currentState!.value !=
                                      //         "") {
                                      //   setState(() {
                                      //     kirattypeerror = "";
                                      //     _kirattypeborderColor = true
                                      //         ? const Color(0xff151f2c)
                                      //         : Colors.white;
                                      //   });
                                      // if (_sexKey.currentState!.value !=
                                      //         null &&
                                      //     _sexKey.currentState!.value != "") {
                                      //   setState(() {
                                      //     sexerror = "";
                                      //     _sexborderColor = true
                                      //         ? const Color(0xff151f2c)
                                      //         : Colors.white;
                                      //   });
                                      //   Map<String, String> credentials =
                                      //       await generateUserCredentials();
                                      //   String? username =
                                      //       credentials["username"];
                                      //   String? password =
                                      //       credentials["password"];
                                      //   setState(() {
                                      //     currentUsername = username!;
                                      //     currentpassword = password!;
                                      //   });
                                      //   print(currentUsername);
                                      // SignUpModel signUpModel =
                                      //     SignUpModel.create(
                                      //         _fullName,
                                      //         currentUsername,
                                      //         password,
                                      //         _kirat_type,
                                      //         _className,
                                      //         _country,
                                      //         _sex,
                                      //         "Al-Fatiha");
                                      if (_fullName != widget.ustaz.fullName) {
                                        setState(() {
                                          print("Errooroororo");
                                          widget.ustaz.fullName = _fullName;
                                        });
                                      }

                                      if (_classNameKey.currentState!.value !=
                                              null &&
                                          _classNameKey.currentState!.value !=
                                              "" &&
                                          _className != widget.ustaz.classId) {
                                        setState(() {
                                          widget.ustaz.classId = _className;
                                        });
                                      }

                                      if (_isChecked == true) {
                                        Map<String, String> credentials =
                                            await generateUserCredentials();
                                        String? username =
                                            credentials["username"];
                                        String? password =
                                            credentials["password"];
                                        setState(() {
                                          currentUsername = username!;
                                          currentpassword = password!;
                                        });

                                        setState(() {
                                          widget.ustaz.newemail = username!;
                                          widget.ustaz.newpassword = password!;
                                        });
                                      }

                                      // setState(() {
                                      //   _fullName = "";
                                      //   _country = "";
                                      //   _password = "";
                                      //   _className = "";
                                      //   _sex = "";
                                      //   _kirat_type = "";
                                      //   _fullnamekey = GlobalKey<
                                      //       FormFieldState<String>>();
                                      //   _kirattypekey = GlobalKey<
                                      //       FormFieldState<String>>();
                                      //   _countryKey = GlobalKey<
                                      //       FormFieldState<String>>();
                                      //   _sexKey = GlobalKey<
                                      //       FormFieldState<String>>();
                                      //   _classNameKey = GlobalKey<
                                      //       FormFieldState<String>>();
                                      //   _fullnamecontroller.text = "";
                                      //   _countrycontroller.text = "";
                                      // });
                                      if (_avatarImageUrl != '') {
                                        setState(() {
                                          widget.ustaz.avatar =
                                              _avatarImageUrl!;
                                        });
                                      }
                                      BlocProvider.of<AdminUstazBloc>(context)
                                          .add(UpdateUstazButton(
                                              ustaz: widget.ustaz));
                                      // } else {
                                      //   setState(() {
                                      //     sexerror = "You must select sex";
                                      //     _sexborderColor = Colors.red;
                                      //   });
                                      // }
                                      // } else {
                                      //   setState(() {
                                      //     kirattypeerror =
                                      //         "You must select kirat type";
                                      //     _kirattypeborderColor = Colors.red;
                                      //   });
                                      // }
                                      // } else {
                                      //   setState(() {
                                      //     classNameError =
                                      //         "You Must Select A class";
                                      //     _classNameborderColor = Colors.red;
                                      //   });
                                      // }
                                    } else {
                                      setState(() {
                                        nameErorr =
                                            "Full Name must be at least 4 characters";
                                        _nameborderColor = Colors.red;
                                      });
                                    }
                                  },
                                )),
                            if (state is StudentOperationProgress)
                              Positioned.fill(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                          ],
                        ),
                        AnimatedPadding(
                          duration: const Duration(milliseconds: 500),
                          padding: EdgeInsets.only(top: size.height * 0.025),
                          child: Row(
                            //TODO: replace text logo with your logo
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Logo',
                                style: GoogleFonts.poppins(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: size.height * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '+',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff3b22a1),
                                  fontSize: size.height * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // RichText(
                        //   textAlign: TextAlign.left,
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: "Finished Your Work Here",
                        //         style: TextStyle(
                        //           color: isDarkMode
                        //               ? Colors.white
                        //               : const Color(0xff1D1617),
                        //           fontSize: size.height * 0.018,
                        //         ),
                        //       ),
                        //       WidgetSpan(
                        //         child: InkWell(
                        //             onTap: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: Text(
                        //               "Go Back",
                        //               style: TextStyle(
                        //                 foreground: Paint()
                        //                   ..shader = const LinearGradient(
                        //                     colors: <Color>[
                        //                       Color(0xffEEA4CE),
                        //                       Color(0xffC58BF2),
                        //                     ],
                        //                   ).createShader(
                        //                     const Rect.fromLTWH(
                        //                       0.0,
                        //                       0.0,
                        //                       200.0,
                        //                       70.0,
                        //                     ),
                        //                   ),
                        //                 fontSize: size.height * 0.018,
                        //               ),
                        //             )),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
        ),
      );
    });
  }
}
