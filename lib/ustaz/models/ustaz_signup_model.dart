class UstazSignUpModel {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String classId;
  final String avatar;

  UstazSignUpModel._(
      {required this.fullName,
      required this.email,
      required this.password,
      required this.role,
      required this.classId,
      required this.avatar});

  static UstazSignUpModel create(
    String fullName,
    String email,
    String password,
    String classId,
    String avatar,
  ) {
    const String role = "ustaz";
    return UstazSignUpModel._(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        classId: classId,
        avatar: avatar);
  }
}
