class Student {
  final String id;
  String fullName;
  final String email;
  String country;
  String sex;
  String kirat_type;
  final String hash;
  final String hashedRt;
  String surah_name;
  int ayah_number;
  final String role;
  String classId;
  bool isSaved;
  bool isPresent;
  int score;
  String newemail;
  String newpassword;
  String avatar;

  Student({
    required this.id,
    required this.fullName,
    required this.email,
    required this.country,
    required this.sex,
    required this.kirat_type,
    required this.hash,
    required this.hashedRt,
    required this.surah_name,
    required this.ayah_number,
    required this.role,
    required this.classId,
    required this.isSaved,
    required this.isPresent,
    this.score = 0,
    this.newemail ='',
    this.newpassword = '',
    this.avatar = ''
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      country: json['country'],
      sex: json['sex'],
      kirat_type: json['kirat_type'],
      hash: json['hash'],
      hashedRt: json['hashedRt'],
      surah_name: json['surah_name'],
      ayah_number: json['ayah_number'],
      role: json['role'],
      classId: json['classId'],
      isPresent: json['isPresent'],
      isSaved: json['isSaved'],
    );
  }

  static Student mapFromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      country: json['country'],
      sex: json['sex'],
      kirat_type: json['kirat_type'],
      hash: json['hash'],
      hashedRt: json['hashedRt'],
      surah_name: json['surah_name'],
      ayah_number: json['ayah_number'],
      role: json['role'],
      classId: json['classId'],
      isPresent: json['isPresent'],
      isSaved: json['isSaved'],
    );
  }
}
