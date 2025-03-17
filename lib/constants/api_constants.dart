class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';

  // Endpoints
  static const String register = '/users';
  static const String login = '/auth/login';
  static const String profile = '/users/profile';
  static const String liverData = '/emr/fatty-liver-indices';

  // 점심 식사 관련 엔드포인트
  static const String lunch = '/lunch';
  static const String lunchByUser = '/lunch/user'; // 사용자별 점심 기록 조회

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
