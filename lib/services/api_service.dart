import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // 사용자 등록 API
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String patientId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'patient_id': patientId,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData,
          'message': responseData['message'] ?? '회원가입이 완료되었습니다.',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ??
              responseData['error'] ??
              '알 수 없는 오류가 발생했습니다.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
      };
    }
  }
}
