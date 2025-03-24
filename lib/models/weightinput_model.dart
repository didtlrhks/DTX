// 체중 기록 모델
class WeightInput {
  final double weight;
  final String weightDate;
  final int userId;

  WeightInput({
    required this.weight,
    required this.weightDate,
    required this.userId,
  });

  // JSON 변환을 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'weight_date': weightDate,
      'user_id': userId,
    };
  }

  // JSON에서 객체 생성을 위한 팩토리 메서드
  factory WeightInput.fromJson(Map<String, dynamic> json) {
    return WeightInput(
      weight: json['weight'].toDouble(),
      weightDate: json['weight_date'],
      userId: json['user_id'],
    );
  }
}
