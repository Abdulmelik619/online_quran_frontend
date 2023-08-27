


import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../student/models/token_model.dart';
import '../models/ustaz_login_details_model.dart';

class UstazLoginCredentials {
  Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void insertLoginCredentials(UstazLoginDetailsModel loginDetailsModel) async {
    final SharedPreferences prefs = await init();
    prefs.setString("access_token", loginDetailsModel.token.accessToken);
    prefs.setString('refresh_token', loginDetailsModel.token.refreshToken);
    prefs.setString("role", loginDetailsModel.ustaz.role);
    prefs.setString("id", loginDetailsModel.ustaz.id);
    prefs.setString("fullName", loginDetailsModel.ustaz.fullName);
    prefs.setString("email", loginDetailsModel.ustaz.email);
    prefs.setString("hash", loginDetailsModel.ustaz.hash);
    prefs.setString("hashedRt", loginDetailsModel.ustaz.hashedRt);
    prefs.setString("classId", loginDetailsModel.ustaz.classId);
    prefs.setString("avatar", loginDetailsModel.ustaz.avatar);

  }

  Future<UstazLoginDetailsModel?> getLoginCredentials() async {
    final SharedPreferences prefs = await init();
    String? accessToken = prefs.getString("access_token");
    String? refreshToken = prefs.getString("refresh_token");
    String? role = prefs.getString("role");
    String? id = prefs.getString("id");
    String? fullName = prefs.getString("fullName");
    String? email = prefs.getString("email");
    String? hash = prefs.getString("hash");
    String? hashedRt = prefs.getString("hashedRt");
    String? classId = prefs.getString("classId");
    String? avatar = prefs.getString("avatar");

    if (id != null &&
        accessToken != null &&
        refreshToken != null &&
        role != null &&
        fullName != null &&
        email != null &&
        hash != null &&
        hashedRt != null &&
        classId != null &&
        avatar != null
        ) {
      Ustaz ustaz = Ustaz(
          id: id,
          fullName: fullName,
          email: email,
          hash: hash,
          hashedRt: hashedRt,
          role: role,
          classId: classId,
          avatar: avatar);

      return UstazLoginDetailsModel.create(
          Token.create(accessToken, refreshToken), ustaz);
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
    prefs.remove("hash");
    prefs.remove("hashedRt");
    prefs.remove("classId");
    prefs.remove("avatar");

  }
}
