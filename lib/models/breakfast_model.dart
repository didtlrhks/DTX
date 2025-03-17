class BreakfastModel {
  String? id;
  String breakfast_text;
  String breakfast_date;
  int user_id;

  BreakfastModel({
    this.id,
    required this.breakfast_text,
    required this.breakfast_date,
    required this.user_id,
  });

  factory BreakfastModel.fromJson(Map<String, dynamic> json) {
    return BreakfastModel(
      id: json['id']?.toString(),
      breakfast_text: json['breakfast_text'] ?? '',
      breakfast_date: json['breakfast_date'] ?? '',
      user_id: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast_text': breakfast_text,
      'breakfast_date': breakfast_date,
      'user_id': user_id,
    };
  }
}
