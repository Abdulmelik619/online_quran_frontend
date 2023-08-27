import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_quran_frontend/student/models/signup_model.dart';
import 'package:online_quran_frontend/student/models/student.dart';

import '../models/login_details.dart';
import '../models/login_model.dart';
import '../models/token_model.dart';

class StudentDataProvider {
  static const String _baseUrl_1 = "http://127.0.0.1:3000/auth/signup/student";
  static const String _baseUrl_2 = "http://127.0.0.1:3000";

  Future<void> signup(SignUpModel student) async {
    var ayah_number = student.ayah_number;
    final http.Response response = await http.post(Uri.parse(_baseUrl_1),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": student.fullName,
          "email": student.email,
          "country": student.country,
          "sex": student.sex,
          "Kirat_type": student.kirat_type,
          "Surah_name": student.surah_name,
          "ayah_number": ayah_number,
          "password": student.password,
          "role": student.role,
          "classId": student.classId,
          "isSaved": false,
          "isPresent": false,
          "avatarUrl": student.avatarUrl
        
        }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.body.substring(1, 4) == "409") {
      throw Exception("Email already Exists");
    } else if (!(response.statusCode == 201)) {
      throw Exception("invalid input");
    }
  }

  Future<void> addClass(
      String className, String dateCreated, String assignedTeacherId) async {
    final http.Response response =
        await http.post(Uri.parse("http://127.0.0.1:3000/student/createclass"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "className": className,
              "dateCreated": dateCreated,
              "assignedTeacherId": assignedTeacherId,
            }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("invalid input");
    }
  }

  login(LoginModel loginModel) async {
    final http.Response response = await http.post(
      Uri.parse("$_baseUrl_2/auth/login"),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode({
        "email": loginModel.email,
        "password": loginModel.password,
        "role": "something",
      }),
    );

    print(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception(response.body);
    }
    final decodedResponse = jsonDecode(response.body);
    // print("hello");
    // print(decodedResponse);
    // print("acccccess: ${decodedResponse[0]['access_token']}");

    // final Token token = Token.create(
    //   decodedResponse[0]['access_token'],
    //   decodedResponse[0]['refresh_token'],
    // );

    // final Map<String, dynamic> user = decodedResponse[1];
    // print(user);
    // final Student realUser = Student.mapFromJson(user);
    // // final String role = decodedResponse['role'];
    // return LoginDetailsModel.create(token, realUser);

    return decodedResponse;
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

  fetchUserProfile(String email) async {
    final http.Response response =
        await http.post(Uri.parse("$_baseUrl_2/student/getStudent"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email,
            }));

    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  updateUserProfile(Student student) async {
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
            }));

    if (response.statusCode == 201) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to update user profile');
    }
  }

  Future<void> deletestudent(String email) async {
    final http.Response response = await http.post(
        Uri.parse("http://127.0.0.1:3000/student/deletestudent"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));
    print(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception("connection problem");
    }
    return;
  }

  Future<void> deleteclass(String id) async {
    print(id);
    final http.Response response =
        await http.post(Uri.parse("http://127.0.0.1:3000/student/deleteclass"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "className": id,
            }));
    print(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception("connection problem");
    }
    return;
  }

  Future<void> deleteustaz(String email) async {
    final http.Response response =
        await http.post(Uri.parse("http://127.0.0.1:3000/ustaz/deleteustaz"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email,
            }));
    print(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception("connection problem");
    }
    return;
  }
}
