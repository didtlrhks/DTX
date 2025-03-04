import '../models/user_model.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class AuthRepository {
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String patientId,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.register,
        {
          'username': username,
          'email': email,
          'password': password,
          'patient_id': patientId,
        },
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final user = User.fromJson(response['data']);
        return {
          'success': true,
          'user': user,
          'message': response['data']['message'] ?? '회원가입이 완료되었습니다.',
        };
      } else {
        return {
          'success': false,
          'message': response['data']['message'] ??
              response['data']['error'] ??
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
