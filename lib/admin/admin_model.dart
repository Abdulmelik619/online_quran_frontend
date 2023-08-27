class Admin {
  final String id;
  final String email;

  final String hash;
  final String hashedRt;

  final String role;

  Admin({
    required this.id,
    required this.email,
    required this.hash,
    required this.hashedRt,
    required this.role,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        id: json['id'],
        email: json['email'],
        hash: json['hash'],
        hashedRt: json['hashedRt'],
        role: json['role'],

        );
  }

  static Admin mapFromJson(Map<String, dynamic> json) {
    return Admin(
        id: json['_id'],
        email: json['email'],
        hash: json['hash'],
        hashedRt: json['hashedRt'],
        role: json['role'],
);
  }
}
