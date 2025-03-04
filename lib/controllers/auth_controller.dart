import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String patientId,
  }) async {
    isLoading.value = true;

    try {
      final result = await _authRepository.registerUser(
        username: username,
        email: email,
        password: password,
        patientId: patientId,
      );

      if (result['success']) {
        user.value = result['user'];
      }

      return result;
    } finally {
      isLoading.value = false;
    }
  }
}
