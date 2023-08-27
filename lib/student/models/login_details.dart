

import 'package:online_quran_frontend/student/models/models.dart';
import 'package:online_quran_frontend/student/models/token_model.dart';

class LoginDetailsModel {
  final Token token;
  
  final Student student;

  LoginDetailsModel._(
      {required this.token, required this.student});

  Map<String, dynamic> toMap() {
    return {
      'id': student.id,
      'access_token': token.accessToken,
      'refresh_token': token.refreshToken,
      'role': student.role,
      'fullName': student.fullName,
      'email': student.email,
      "country": student.country,
      "sex": student.sex,
      "kirat_type": student.kirat_type,
      "ayah_number": student.ayah_number
    };
  }

  factory LoginDetailsModel.fromMap(Map<String, dynamic> map) {
    Token token = Token.create(map["access_token"], map["refresh_token"]);
    
    Student student = Student(
      id: map["id"],
      fullName: map["fullName"],
      email: map["email"],
      country: map["country"],
      sex: map["sex"],
      kirat_type: map["kirat_type"],
      ayah_number: map["kirat_type"],
      surah_name: map["surah_name"],
      role: map["role"],
      hash: map["hash"],
      hashedRt: map["hashedRt"],
      classId: map["classId"],
      isSaved: map["isSaved"],
      isPresent: map["isPresent"],
     
    );
    return LoginDetailsModel._(
        token: token, student: student );
  }

  static LoginDetailsModel create(
      Token accessToken,  Student student) {
    return LoginDetailsModel._(
        token: accessToken, student: student);
  }
}