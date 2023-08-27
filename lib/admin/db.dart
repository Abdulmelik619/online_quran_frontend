

import 'package:online_quran_frontend/admin/admin_login_details_model.dart';
import 'package:online_quran_frontend/admin/admin_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../student/models/token_model.dart';

class AdminLoginCredentials {
  Future<SharedPreferences> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void insertLoginCredentials(AdminLoginDetailsModel loginDetailsModel) async {
    final SharedPreferences prefs = await init();
    prefs.setString("access_token", loginDetailsModel.token.accessToken);
    prefs.setString('refresh_token', loginDetailsModel.token.refreshToken);
    prefs.setString("role", loginDetailsModel.admin.role);
    prefs.setString("id", loginDetailsModel.admin.id);
    prefs.setString("email", loginDetailsModel.admin.email);
    prefs.setString("hash", loginDetailsModel.admin.hash);
    prefs.setString("hashedRt", loginDetailsModel.admin.hashedRt);
  }

  Future<AdminLoginDetailsModel?> getLoginCredentials() async {
    final SharedPreferences prefs = await init();
    String? accessToken = prefs.getString("access_token");
    String? refreshToken = prefs.getString("refresh_token");
    String? role = prefs.getString("role");
    String? id = prefs.getString("id");
    String? email = prefs.getString("email");
    String? hash = prefs.getString("hash");
    String? hashedRt = prefs.getString("hashedRt");

    if (id != null &&
        accessToken != null &&
        refreshToken != null &&
        role != null &&
        email != null &&
        hash != null &&
        hashedRt != null 
        ) {
      Admin ustaz = Admin(
          id: id,
          email: email,
          hash: hash,
          hashedRt: hashedRt,
          role: role,
          );

      return AdminLoginDetailsModel.create(
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
    prefs.remove("email");
    prefs.remove("hash");
    prefs.remove("hashedRt");
  }
}
