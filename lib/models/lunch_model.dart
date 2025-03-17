class LunchModel {
  final String? id;
  final String lunch_text;
  final String lunch_date;
  final int user_id;

  LunchModel({
    this.id,
    required this.lunch_text,
    required this.lunch_date,
    required this.user_id,
  });

  factory LunchModel.fromJson(Map<String, dynamic> json) {
    return LunchModel(
      id: json['id']?.toString(),
      lunch_text: json['lunch_text'] ?? '',
      lunch_date: json['lunch_date'] ?? '',
      user_id: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'lunch_text': lunch_text,
      'lunch_date': lunch_date,
      'user_id': user_id,
    };
  }
}
