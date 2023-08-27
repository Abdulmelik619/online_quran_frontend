import '../data_providers/avatar.dart';

class SignUpModel {
  final String fullName;
  final String? email;
  final String country;
  final String sex;
  final String kirat_type;
  final String? password;
  final String surah_name;
  final int ayah_number;
  final String role;
  final String classId;
  final String? avatarUrl;

  SignUpModel._({
    required this.fullName,
    required this.email,
    required this.country,
    required this.sex,
    required this.kirat_type,
    required this.password,
    required this.surah_name,
    required this.ayah_number,
    required this.role,
    required this.classId,
    required this.avatarUrl
  });

  static SignUpModel create(
    String fullName,
    String? email,
    String? password,
    String kirat_type,
    final classId,
    String country,
    String sex,
    String surah_name,
AvatarModel? avatar,

  ) {
        String alternateAvatar;

     if (avatar == null || avatar.toString() == "") {
      alternateAvatar = "";
    } else {
      alternateAvatar = avatar.toString();
    }


    
    const String role = "deresa";
    const int ayah_number = 0;
    return SignUpModel._(
      fullName: fullName,
      email: email,
      password: password,
      country: country,
      kirat_type: kirat_type,
      sex: sex,
      surah_name: surah_name,
      ayah_number: ayah_number,
      role: role,
      classId: classId,
      avatarUrl: alternateAvatar
    );
  }
}
