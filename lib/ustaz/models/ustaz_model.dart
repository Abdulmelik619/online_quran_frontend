class Ustaz {
  final String id;
  String fullName;
  final String email;

  final String hash;
  final String hashedRt;

  final String role;
  String classId;

  String newemail;
  String newpassword;

  String avatar;

  Ustaz(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.hash,
      required this.hashedRt,
      required this.role,
      required this.classId,
      this.newemail = "",
      this.newpassword = "",
      required this.avatar});

  factory Ustaz.fromJson(Map<String, dynamic> json) {
    return Ustaz(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      hash: json['hash'],
      hashedRt: json['hashedRt'],
      role: json['role'],
      classId: json['classId'],
      avatar: json["avatar"]
    );
  }

  static Ustaz mapFromJson(Map<String, dynamic> json) {
    return Ustaz(
        id: json['_id'],
        fullName: json['fullName'],
        email: json['email'],
        hash: json['hash'],
        hashedRt: json['hashedRt'],
        role: json['role'],
        classId: json['classId'],
        avatar: json['avatar']);
  }
}
