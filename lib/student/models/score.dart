class Score {
  final String student_id;
  String date;
  final String score;
 
 
  Score({
    required this.student_id,
    required this.date,
    required this.score,
    
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      student_id: json['student_id'],
      date: json['class_id'],
      score: json['score'],
      
      
    );
  }

  static Score mapFromJson(Map<String, dynamic> json) {
    return Score  (
      student_id: json['student_id'],
      date: json['class_id'],
      score: json['date'],
      
    );
  }
}
