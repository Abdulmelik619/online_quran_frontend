class Abscent {
  final String student_id;
  String class_id;
  final String date;
 
 
  Abscent({
    required this.student_id,
    required this.class_id,
    required this.date,
    
  });

  factory Abscent.fromJson(Map<String, dynamic> json) {
    return Abscent(
      student_id: json['student_id'],
      class_id: json['class_id'],
      date: json['date'],
      
      
    );
  }

  static Abscent mapFromJson(Map<String, dynamic> json) {
    return Abscent  (
      student_id: json['student_id'],
      class_id: json['class_id'],
      date: json['date'],
      
    );
  }
}
