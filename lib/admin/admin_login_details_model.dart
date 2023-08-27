


import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../student/models/token_model.dart';
import 'admin_model.dart';

class AdminLoginDetailsModel {
  final Token token;
  
  final Admin admin;

  AdminLoginDetailsModel._(
      {required this.token, required this.admin});

  Map<String, dynamic> toMap() {
    return {
      'id': admin.id,
      'access_token': token.accessToken,
      'refresh_token': token.refreshToken,
      'role': admin.role,
      'email': admin.email,
    };
  }

  factory AdminLoginDetailsModel.fromMap(Map<String, dynamic> map) {
    Token token = Token.create(map["access_token"], map["refresh_token"]);
    
    Admin admin = Admin(
      id: map["id"],
      email: map["email"],
      role: map["role"],
      hash: map["hash"],
      hashedRt: map["hashedRt"],
     
    );
    return AdminLoginDetailsModel._(
        token: token, admin: admin );
  }

  static AdminLoginDetailsModel create(
      Token accessToken,  Admin admin) {
    return AdminLoginDetailsModel._(
        token: accessToken, admin: admin);
  }
}