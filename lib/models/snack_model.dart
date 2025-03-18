class SnackModel {
  String? id;
  String snack_text;
  String snack_date;
  int user_id;

  SnackModel({
    this.id,
    required this.snack_text,
    required this.snack_date,
    required this.user_id,
  });

  factory SnackModel.fromJson(Map<String, dynamic> json) {
    return SnackModel(
      id: json['id']?.toString(),
      snack_text: json['snack_text'] ?? '',
      snack_date: json['snack_date'] ?? '',
      user_id: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'snack_text': snack_text,
      'snack_date': snack_date,
      'user_id': user_id,
    };
  }
}
