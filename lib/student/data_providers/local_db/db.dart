import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_quran_frontend/student/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/login_details.dart';
import '../../models/token_model.dart';

class LoginCredentials {
  Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void insertLoginCredentials(LoginDetailsModel loginDetailsModel) async {
    final SharedPreferences prefs = await init();
    prefs.setString("access_token", loginDetailsModel.token.accessToken);
    prefs.setString('refresh_token', loginDetailsModel.token.refreshToken);
    prefs.setString("role", loginDetailsModel.student.role);
    prefs.setString("id", loginDetailsModel.student.id);
    prefs.setString("fullName", loginDetailsModel.student.fullName);
    prefs.setString("email", loginDetailsModel.student.email);
    prefs.setString("country", loginDetailsModel.student.country);
    prefs.setString("sex", loginDetailsModel.student.sex);
    prefs.setString("surah_name", loginDetailsModel.student.surah_name);
    prefs.setInt("ayah_number", loginDetailsModel.student.ayah_number);
    prefs.setString("kirat_type", loginDetailsModel.student.kirat_type);
    prefs.setString("hash", loginDetailsModel.student.hash);
    prefs.setString("hashedRt", loginDetailsModel.student.hashedRt);
    prefs.setString("classId", loginDetailsModel.student.classId);
    prefs.setBool("isSaved", loginDetailsModel.student.isSaved);
    prefs.setBool("isPresent", loginDetailsModel.student.isPresent);
  }

  Future<LoginDetailsModel?> getLoginCredentials() async {
    final SharedPreferences prefs = await init();
    String? accessToken = prefs.getString("access_token");
    String? refreshToken = prefs.getString("refresh_token");
    String? role = prefs.getString("role");
    String? id = prefs.getString("id");
    String? fullName = prefs.getString("fullName");
    String? email = prefs.getString("email");
    String? country = prefs.getString("country");
    String? sex = prefs.getString("sex");
    String? surah_name = prefs.getString("surah_name");
    int? ayah_number = prefs.getInt("ayah_number");
    String? kirat_type = prefs.getString("kirat_type");
    String? hash = prefs.getString("hash");
    String? hashedRt = prefs.getString("hashedRt");
    String? classId = prefs.getString("classId");
    bool? isSaved = prefs.getBool("isSaved");
    bool? isPresent = prefs.getBool("isPresent");

    if (id != null &&
        accessToken != null &&
        refreshToken != null &&
        role != null &&
        fullName != null &&
        email != null &&
        country != null &&
        sex != null &&
        surah_name != null &&
        ayah_number != null &&
        hash != null &&
        hashedRt != null &&
        kirat_type != null &&
        classId != null &&
        isSaved != null &&
        isPresent != null) {
      Student student = Student(
          id: id,
          fullName: fullName,
          email: email,
          country: country,
          sex: sex,
          kirat_type: kirat_type,
          surah_name: surah_name,
          ayah_number: ayah_number,
          hash: hash,
          hashedRt: hashedRt,
          role: role,
          classId: classId,
          isPresent: isPresent,
          isSaved: isSaved);

      return LoginDetailsModel.create(
          Token.create(accessToken, refreshToken), student);
    }
    return null;
  }

  Future<void> deleteLoginCredentials() async {
    final SharedPreferences prefs = await init();
    prefs.remove("access_token");
    prefs.remove("referesh_token");
    prefs.remove("role");
    prefs.remove("id");
    prefs.remove("fullName");
    prefs.remove("email");
    prefs.remove("country");
    prefs.remove("sex");
    prefs.remove("surah_name");
    prefs.remove("ayah_number");
    prefs.remove("kirat_type");
    prefs.remove("hash");
    prefs.remove("hashedRt");
    prefs.remove("classId");
    prefs.remove("isSaved");
    prefs.remove("isPresent");
    
  }
}
