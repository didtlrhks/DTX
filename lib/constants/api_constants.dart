class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';

  // Endpoints
  static const String register = '/users';
  static const String login = '/auth/login';
  static const String profile = '/users/profile';
  static const String liverData = '/emr/fatty-liver-indices';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
