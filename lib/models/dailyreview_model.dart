class DailyReview {
  final int? userId;
  final String reviewDate;
  final int hungerOption;
  final String hungerText;
  final int sleepOption;
  final String sleepText;
  final int activityOption;
  final String activityText;
  final int emotionOption;
  final String emotionText;
  final int alcoholOption;
  final String alcoholText;
  final String? comment;

  DailyReview({
    this.userId,
    required this.reviewDate,
    required this.hungerOption,
    required this.hungerText,
    required this.sleepOption,
    required this.sleepText,
    required this.activityOption,
    required this.activityText,
    required this.emotionOption,
    required this.emotionText,
    required this.alcoholOption,
    required this.alcoholText,
    this.comment,
  });

  // JSON 변환을 위한
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'review_date': reviewDate,
      'hunger_option': hungerOption,
      'hunger_text': hungerText,
      'sleep_option': sleepOption,
      'sleep_text': sleepText,
      'activity_option': activityOption,
      'activity_text': activityText,
      'emotion_option': emotionOption,
      'emotion_text': emotionText,
      'alcohol_option': alcoholOption,
      'alcohol_text': alcoholText,
      'comment': comment ?? '',
    };
  }

  // JSON에서 객체 생성
  factory DailyReview.fromJson(Map<String, dynamic> json) {
    return DailyReview(
      userId: json['user_id'],
      reviewDate: json['review_date'],
      hungerOption: json['hunger_option'],
      hungerText: json['hunger_text'],
      sleepOption: json['sleep_option'],
      sleepText: json['sleep_text'],
      activityOption: json['activity_option'],
      activityText: json['activity_text'],
      emotionOption: json['emotion_option'],
      emotionText: json['emotion_text'],
      alcoholOption: json['alcohol_option'],
      alcoholText: json['alcohol_text'],
      comment: json['comment'],
    );
  }
}
