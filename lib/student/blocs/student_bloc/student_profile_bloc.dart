import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_event.dart';
import 'package:online_quran_frontend/student/blocs/student_bloc/student_state.dart';
import 'package:online_quran_frontend/student/models/models.dart';
import 'package:online_quran_frontend/student/repository/student_repository.dart';
import 'package:http/http.dart' as http;

import '../../models/abscent.dart';
import '../../models/score.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  StudentBloc({required this.studentRepository})
      : super(StudentProfileLoadingState()) {
    on<StudentProfileLoadEvent>((event, emit) async {
      emit(StudentProfileLoadingState());

      try {
        final studentProfile =
            await studentRepository.fetchUserProfile(event.email);

        Student student = Student(
            id: studentProfile["_id"],
            fullName: studentProfile["fullName"],
            email: studentProfile['email'],
            country: studentProfile["country"],
            sex: studentProfile["sex"],
            kirat_type: studentProfile["kirat_type"],
            hash: studentProfile["hash"],
            hashedRt: studentProfile["hashedRt"],
            surah_name: studentProfile["surah_name"],
            ayah_number: studentProfile["ayah_number"],
            role: studentProfile["role"],
            classId: studentProfile["classId"],
            isSaved: studentProfile["isSaved"],
            isPresent: studentProfile["isPresent"],
            avatar: studentProfile["avatarUrl"]);

        emit(StudentProfileLoadSuccess(student: student));
      } catch (error) {
        emit(UserProfileError('Failed to load user profile: $error'));
      }
    });

    on<Navigate>((event, emit) async {
      emit(StudentScoreLoadingState());

      try {
        final studentProfile =
            await studentRepository.fetchUserProfile(event.email);

        Student student = Student(
            id: studentProfile["_id"],
            fullName: studentProfile["fullName"],
            email: studentProfile['email'],
            country: studentProfile["country"],
            sex: studentProfile["sex"],
            kirat_type: studentProfile["kirat_type"],
            hash: studentProfile["hash"],
            hashedRt: studentProfile["hashedRt"],
            surah_name: studentProfile["surah_name"],
            ayah_number: studentProfile["ayah_number"],
            role: studentProfile["role"],
            classId: studentProfile["classId"],
            isSaved: studentProfile["isSaved"],
            isPresent: studentProfile["isPresent"],
            avatar: studentProfile["avatarUrl"]);

        emit(StudentProfileLoadSuccess(student: student));
      } catch (error) {
        emit(UserProfileError('Failed to load user profile: $error'));
      }
    });

    on<StudentAbscentLoadEvent>((event, emit) async {
      emit(StudentScoreLoadingState());

      try {
        final http.Response response = await http.post(
            Uri.parse("http://127.0.0.1:3000/student/getAbscentsbyId"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "studentId": event.id,
            }));

        final abscents = jsonDecode(response.body);
        List<Abscent> abscents_fetced = [];

        for (var Abscnett in abscents) {
          Abscent abscent = Abscent(
            student_id: Abscnett["student_id"],
            class_id: Abscnett["class_id"],
            date: Abscnett['date'],
          );
          abscents_fetced.add(abscent);
        }

        emit(StudentAbscentLoadSuccess(abscents: abscents_fetced));
      } catch (error) {
        emit(UserProfileError('Failed to load user profile: $error'));
      }
    });

    on<StudentScoreLoadEvent>((event, emit) async {
      emit(StudentScoreLoadingState());

      try {
        final http.Response response = await http.post(
            Uri.parse("http://127.0.0.1:3000/student/getScorebyId"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "studentId": event.id,
            }));

        final scores = jsonDecode(response.body);
        print("here$scores");
        List<Score> scores_fetced = [];

        for (var scoree in scores) {
          Score score = Score(
            student_id: scoree["student_id"],
            date: scoree["date"],
            score: scoree['score'].toString(),
          );
          scores_fetced.add(score);
        }
        print("scores$scores");
        emit(StudentScoreLoadSuccess(scores: scores_fetced));
      } catch (error) {
        emit(UserProfileError('Failed to load user profile: $error'));
      }
    });

    on<StudentProfileUpdateEvent>((event, emit) async {
      // if (state is UserProfileLoading) return;
      emit(StudentProfileLoadingState());
      try {
        final studentProfile =
            await studentRepository.updateUserProfile(event.student);

        Student student = Student(
            id: studentProfile["_id"],
            fullName: studentProfile["fullName"],
            email: studentProfile['email'],
            country: studentProfile["country"],
            sex: studentProfile["sex"],
            kirat_type: studentProfile["kirat_type"],
            hash: studentProfile["hash"],
            hashedRt: studentProfile["hashedRt"],
            surah_name: studentProfile["surah_name"],
            ayah_number: studentProfile["ayah_number"],
            role: studentProfile["role"],
            classId: studentProfile["classId"],
            isSaved: studentProfile["isSaved"],
            isPresent: studentProfile["isPresent"]);

        emit(StudentProfileUpdateSuccess(student: student));
      } catch (error) {
        emit(UserProfileError('Failed to load user profile: $error'));
      }
    });
  }
}
