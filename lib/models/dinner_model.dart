class DinnerModel {
  final String? id;
  final String dinner_text;
  final String dinner_date;
  final int user_id;

  DinnerModel({
    this.id,
    required this.dinner_text,
    required this.dinner_date,
    required this.user_id,
  });

  factory DinnerModel.fromJson(Map<String, dynamic> json) {
    return DinnerModel(
      id: json['id']?.toString(),
      dinner_text: json['dinner_text'] ?? '',
      dinner_date: json['dinner_date'] ?? '',
      user_id: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dinner_text': dinner_text,
      'dinner_date': dinner_date,
      'user_id': user_id,
    };
  }
}
