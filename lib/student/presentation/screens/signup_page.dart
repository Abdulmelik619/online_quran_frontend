import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_quran_frontend/student/presentation/screens/signup_error_page.dart';

import '../../blocs/student_bloc/signup_bloc.dart';
import '../../blocs/student_bloc/student_state.dart';
import '../components/signup_body.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpBloc, StudentState>(listener: (context, state) {
        if (state is SignUpOperationSuccess) {
          // GoRouter.of(context).push("/login");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "account created successfully, click on the login button to log into your account"),
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (state is SignUpFailureState &&
            state.error.toString() == "Exception: Email already Exists") {
          {
            print(state.error.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("An error occured: Email already Exists"),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } else if (state is SignUpFailureState) {
          {
            print(state.error.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("something went wrong, please try again"),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      }, builder: (context, state) {
        switch (state.runtimeType) {
          case SignUpFailureState || SignUpLoading || SignUpOperationSuccess:
            return const SIgnUpBody();
          case SignUpOperationLoading:
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));

          default:
            return const ErrorPage();
        }
      }),
    );
  }
}
