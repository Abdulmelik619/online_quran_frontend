import 'dart:convert';

import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../admin/class_model.dart';
import '../../student/models/login_model.dart';
import '../../student/models/student.dart';
import '../../student/models/token_model.dart';
import '../models/ustaz_login_details_model.dart';
import '../models/ustaz_signup_model.dart';
import 'package:http/http.dart' as http;

class UstazDataProvider {
  static const String _baseUrl_1 = "http://127.0.0.1:3000/auth/signup/ustaz";
  static const String _baseUrl_2 = "http://127.0.0.1:3000";

  Future<void> signupUstaz(UstazSignUpModel ustaz) async {
    final http.Response response = await http.post(Uri.parse(_baseUrl_1),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": ustaz.fullName,
          "email": ustaz.email,
          "password": ustaz.password,
          "role": ustaz.role,
          "classId": ustaz.classId,
          "avatar": ustaz.avatar
        }));
    if (response.body.substring(1, 4) == "409") {
      throw Exception("Email already Exists");
    } else if (!(response.statusCode == 201)) {
      throw Exception("invalid input");
    }
  }

  Future<UstazLoginDetailsModel> login(LoginModel loginModel) async {
    final http.Response response = await http.post(
      Uri.parse("$_baseUrl_2/auth/login"),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode({
        "email": loginModel.email,
        "password": loginModel.password,
        "role": "ustaz",
      }),
    );

    print(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception(response.body);
    }
    final decodedResponse = jsonDecode(response.body);
    print("hello");
    print(decodedResponse);
    print("acccccess: ${decodedResponse[0]['access_token']}");

    final Token token = Token.create(
      decodedResponse[0]['access_token'],
      decodedResponse[0]['refresh_token'],
    );
    final Map<String, dynamic> user = decodedResponse[1];
    print(user);
    final Ustaz realUser = Ustaz.mapFromJson(user);
    // final String role = decodedResponse['role'];
    return UstazLoginDetailsModel.create(token, realUser);
  }

  Future<void> logout(String email) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/auth/logout"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email,
            }));

    if (response.statusCode != 201) {
      throw Exception("invalid credentials or connection problem");
    }
    return;
  }

  getstudentsOfclass(String classId) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/getStudentbyclass"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "classId": classId,
            }));

    if (response.statusCode == 201) {
      final students = jsonDecode(response.body);
      return students;
    } else {
      throw Exception('Failed to fetch Students');
    }
  }

  getallstudents() async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/getallstudents"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: null);

    if (response.statusCode == 201) {
      final students = jsonDecode(response.body);
      return students;
    } else {
      throw Exception('Failed to fetch Students');
    }
  }

  getallclasses() async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/getallclasses"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: null);

    if (response.statusCode == 201) {
      final students = jsonDecode(response.body);
      return students;
    } else {
      throw Exception('Failed to fetch Students');
    }
  }

 getallustazs() async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/ustaz/getallUstazs"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: null);

    if (response.statusCode == 201) {
      final students = jsonDecode(response.body);
      return students;
    } else {
      throw Exception('Failed to fetch Students');
    }
  }

  updateUserProfile(Student student) async {
    print("hello world");
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/updateProfile"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "fullName": student.fullName,
              "email": student.email,
              "country": student.country,
              "sex": student.sex,
              "Kirat_type": student.kirat_type,
              "Surah_name": student.surah_name,
              "ayah_number": student.ayah_number,
              "password": student.hash,
              "role": student.role,
              "isPresent": student.isPresent,
              "isSaved": student.isSaved,
              "classId": student.classId,
              "newemail": student.newemail,
              "newpassword": student.newpassword,
              "avatarUrl": student.avatar
            }));

    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to update user profile');
    }
  }

 updateClassProfile(Classs classs) async {
    print("hello world");
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/updateClass"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "classId": classs.id,
              "className": classs.className,
              "dateCreated": classs.dateCreated,
              "assignedTeacherId": classs.assignedTeacherId,
             
             
            }));

    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to update user profile');
    }
  }

updatestazProfile(Ustaz ustaz) async {
    print("hello world");
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/ustaz/updateustazProfile"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "fullName": ustaz.fullName,
              "email": ustaz.email,
              "password": ustaz.hash,
              "role": ustaz.role,
              "classId": ustaz.classId,
              "newemail": ustaz.newemail,
              "newpassword": ustaz.newpassword, 
              "avatar": ustaz.avatar
            }));

    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to update user profile');
    }
  }
  Future<dynamic> addmark(String student_id, int date, int score, int end_ayah,
      String end_surah) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/addmark"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "student_id": student_id,
              "date": date,
              "score": score,
              "end_ayah": end_ayah,
              "end_surah": end_surah,
            }));
    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to add mark');
    }
  }

  Future<dynamic> deletemark(String student_id, int date) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/deleteMark"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "studentId": student_id,
              "date": date,
            }));
    if (response.statusCode == 201) {
      String str = "some thing";
      return str;
    } else {
      throw Exception('Failed to delete mark');
    }
  }

  Future<dynamic> addabscent(
      String student_id, String class_id, int date) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/addabscent"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "student_id": student_id,
              "class_id": class_id,
              "date": date,
            }));
    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to add abscent');
    }
  }

  Future<dynamic> deleteAbscent(String student_id, int date) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/deleteAbscent"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "studentId": student_id,
              "date": date,
            }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      String str = "some thing";
      return str;
    } else {
      throw Exception('Failed to add abscent');
    }
  }

  // fetchUserProfile(String email) async {
  //   final http.Response response =
  //       await http.post(Uri.parse("$_baseUrl_2/getStudent"),
  //           headers: <String, String>{"Content-Type": "application/json"},
  //           body: jsonEncode({
  //             "email": email,
  //           }));

  //   if (response.statusCode == 201) {
  //     final user = jsonDecode(response.body);
  //     return user;
  //   } else {
  //     throw Exception('Failed to fetch user profile');
  //   }
  // }

  // updateUserProfile(Student student) async {
  //   final http.Response response =
  //       await http.post(Uri.parse("$_baseUrl_2/updateProfile"),
  //           headers: <String, String>{"Content-Type": "application/json"},
  //           body: jsonEncode({
  //             "fullName": student.fullName,
  //             "email": student.email,
  //             "country": student.country,
  //             "sex": student.sex,
  //             "Kirat_type": student.kirat_type,
  //             "Surah_name": student.surah_name,
  //             "ayah_number": student.ayah_number,
  //             "password": student.hash,
  //             "role": student.role,
  //           }));

  //   if (response.statusCode == 201) {
  //     final user = jsonDecode(response.body);
  //     return user;
  //   } else {
  //     throw Exception('Failed to update user profile');
  //   }
  // }
}
