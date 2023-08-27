


import 'package:online_quran_frontend/ustaz/models/ustaz_model.dart';

import '../../student/models/token_model.dart';

class UstazLoginDetailsModel {
  final Token token;
  
  final Ustaz ustaz;

  UstazLoginDetailsModel._(
      {required this.token, required this.ustaz});

  Map<String, dynamic> toMap() {
    return {
      'id': ustaz.id,
      'access_token': token.accessToken,
      'refresh_token': token.refreshToken,
      'role': ustaz.role,
      'fullName': ustaz.fullName,
      'email': ustaz.email,
     'classId': ustaz.classId
    };
  }

  factory UstazLoginDetailsModel.fromMap(Map<String, dynamic> map) {
    Token token = Token.create(map["access_token"], map["refresh_token"]);
    
    Ustaz ustaz = Ustaz(
      id: map["id"],
      fullName: map["fullName"],
      email: map["email"],
      role: map["role"],
      hash: map["hash"],
      hashedRt: map["hashedRt"],
      classId: map["classId"],
      avatar: map['avatar']
     
    );
    return UstazLoginDetailsModel._(
        token: token, ustaz: ustaz );
  }

  static UstazLoginDetailsModel create(
      Token accessToken,  Ustaz ustaz) {
    return UstazLoginDetailsModel._(
        token: accessToken, ustaz: ustaz);
  }
}