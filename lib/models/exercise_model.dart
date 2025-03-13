class ExerciseModel {
  final String exercise_text; // 서버 API와 일치하도록 필드명 변경
  final String intensity; // "저강도", "중강도", "고강도" 형식
  final String exercise_date; // "YYYY-MM-DD" 형식
  final int user_id; // 서버 API와 일치하도록 필드명 변경
  final String? id;

  ExerciseModel({
    required this.exercise_text,
    required this.intensity,
    required this.exercise_date,
    required this.user_id,
    this.id,
  });

  // 강도 값을 숫자에서 문자열로 변환
  static String intensityToString(int intensityValue) {
    switch (intensityValue) {
      case 1:
        return '저강도';
      case 2:
        return '중강도';
      case 3:
        return '고강도';
      default:
        return '저강도';
    }
  }

  // 강도 문자열을 숫자로 변환
  static int intensityToInt(String intensityString) {
    switch (intensityString) {
      case '저강도':
        return 1;
      case '중강도':
        return 2;
      case '고강도':
        return 3;
      default:
        return 1;
    }
  }

  // JSON에서 모델로 변환
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString(),
      exercise_text: json['exercise_text'] ?? '',
      intensity: json['intensity'] ?? '저강도',
      exercise_date: json['exercise_date'] ?? '',
      user_id: json['user_id'] ?? 0,
    );
  }

  // 모델에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'exercise_text': exercise_text,
      'intensity': intensity,
      'exercise_date': exercise_date,
      'user_id': user_id,
      if (id != null) 'id': id,
    };
  }
}
