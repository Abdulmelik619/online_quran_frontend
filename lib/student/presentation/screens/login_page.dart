import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_quran_frontend/student/data_providers/student_data_provider.dart';
import 'package:online_quran_frontend/student/presentation/screens/student_profile_screen.dart';
import 'package:online_quran_frontend/student/presentation/screens/ustaz_profile_screen.dart';
import 'package:online_quran_frontend/student/repository/student_repository.dart';

import '../../blocs/student_bloc/login_bloc.dart';
import '../../blocs/student_bloc/student_event.dart';
import '../../blocs/student_bloc/student_state.dart';
import '../../models/login_model.dart';
import 'admin__profile_screen.dart';
import 'student_evaluation.dart';

class LogIn extends StatefulWidget {
  const LogIn({
    super.key,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  LoginBloc loginBloc = LoginBloc(
      studentRepository:
          StudentRepository(dataProvider: StudentDataProvider()));

  // @override
  // void initState() {
  //   loginBloc.add(LoadLogin());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<LoginBloc, StudentState>(
      listener: (context, state) {
        // if (state is LoginSuccess) {
        //   GoRouter.of(context).pushReplacement("/");
        // } else
        if (state is LoginFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("invalid credentials or connection problem"),
            ),
          );
        }
      },
      builder: (context, state) {
        print("here is it: ${state.runtimeType}");
        switch (state.runtimeType) {
          case LoginOperationLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case LoginLoadingState:
          case LoginFailureState:
            return const LoginBody();
          case LoginSuccessState:
            return StudentProfileScreen();
          case UstazLoginSuccessState:
            return UstazProfileScreen();
          case AdminLoginSuccessState:
            print("object");
            return AdminProfileScreen();
          default:
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
        }
      },
    ));
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginBody> {
  Color _emailborderColor = true ? const Color(0xff151f2c) : Colors.white;
  Color _passwordborderColor = true ? const Color(0xff151f2c) : Colors.white;

  static String emailError = "";
  static String passworderror = "";

  static String _password = "";
  static String _email = "";

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _passwordKey = GlobalKey<FormFieldState<String>>();

  bool pwVisible = false;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = Brightness.dark;
    bool isDarkMode = brightness == Brightness.dark;

    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Container(
                    padding: EdgeInsets.only(top: size.height * 0.1),
                    height: size.height,
                    width: size.width * 1.1,
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xff151f2c) : Colors.white,
                    ),
                    child: SafeArea(
                      child: Stack(children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.02),
                                child: Align(
                                  child: Text(
                                    'Hey there,',
                                    style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.015),
                                child: Align(
                                  child: Text(
                                    'Welcome Back',
                                    style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.01),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.025),
                                  child: Container(
                                    width: size.width * 0.9,
                                    // height: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                        color: _emailborderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Form(
                                      child: TextFormField(
                                        key: _emailKey,
                                        controller: _emailcontroller,
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
                                              Icons.email_outlined,
                                              color: const Color(0xff7B6F72),
                                            ),
                                          ),
                                          hintText: 'Email',
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
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
                                            _email = newValue!;
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
                              emailError != ""
                                  ? Text(
                                      emailError,
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.025),
                                  child: Container(
                                    width: size.width * 0.9,
                                    // height: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                        color: _passwordborderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Form(
                                      child: TextFormField(
                                        key: _passwordKey,
                                        controller: _passwordcontroller,
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? const Color(0xffADA4A5)
                                                : Colors.black),
                                        obscureText: true ? !pwVisible : false,
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
                                              Icons.lock_outlined,
                                              color: const Color(0xff7B6F72),
                                            ),
                                          ),
                                          suffixIcon: true
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    top: size.height * 0.005,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        pwVisible = !pwVisible;
                                                      });
                                                    },
                                                    child: pwVisible
                                                        ? const Icon(
                                                            Icons
                                                                .visibility_off_outlined,
                                                            color: Color(
                                                                0xff7B6F72),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .visibility_outlined,
                                                            color: Color(
                                                                0xff7B6F72),
                                                          ),
                                                  ),
                                                )
                                              : null,
                                          hintText: 'Password',
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
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
                                            _password = newValue!;
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
                              passworderror != ""
                                  ? Text(
                                      passworderror,
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                              AnimatedPadding(
                                  duration: const Duration(milliseconds: 500),
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.025),
                                  child: ElevatedButton(
                                    child: Text("Login"),
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

                                      if (_emailKey
                                                  .currentState!.value!.length >=
                                              5 ) {
                                        setState(() {
                                          _email =
                                              _emailKey.currentState!.value!;
                                          emailError = "";
                                          _emailborderColor = true
                                              ? const Color(0xff151f2c)
                                              : Colors.white;
                                        });
                                        if (_passwordKey
                                                .currentState!.value!.length >=
                                            4) {
                                          setState(() {
                                            _password = _passwordKey
                                                .currentState!.value!;
                                            passworderror = "";
                                            _passwordborderColor = true
                                                ? const Color(0xff151f2c)
                                                : Colors.white;
                                          });

                                          print("Login");
                                          LoginModel loginModel = LoginModel(
                                              email: _email,
                                              password: _password);

                                          BlocProvider.of<LoginBloc>(context)
                                              .add(LoginButtonPressed(
                                                  loginModel: loginModel));
                                        } else {
                                          setState(() {
                                            passworderror =
                                                "password must be at least 6 characters";
                                            _passwordborderColor = Colors.red;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          emailError = "Invalid Email";
                                          _emailborderColor = Colors.red;
                                        });
                                      }
                                    },
                                  )),
                              AnimatedPadding(
                                duration: const Duration(milliseconds: 500),
                                padding: EdgeInsets.only(
                                  top: size.height * 0.05,
                                ),
                                child: Row(
                                  //TODO: replace text logo with your logo
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Logo',
                                      style: GoogleFonts.poppins(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
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
                              
                            ],
                          ),
                        ),
                      ]),
                    )))));
  }
}
