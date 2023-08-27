import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentErrorPage extends StatefulWidget {
  const StudentErrorPage({super.key});

  @override
  State<StudentErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<StudentErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("something went wrong"),
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green[200],
              textStyle: const TextStyle(color: Colors.black),
            ),
            onPressed: () {
              // GoRouter.of(context).pop();
              GoRouter.of(context).push("/studentprofile");
            },
            child: const Text("go back"))
      ],
    );
  }
}
