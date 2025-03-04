import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_complete_page.dart';
import '../controllers/auth_controller.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _authController = Get.put(AuthController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();

  Future<void> _verifyPatient() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _patientIdController.text.isEmpty) {
      Get.snackbar(
        '입력 오류',
        '모든 필드를 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    final result = await _authController.register(
      username: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      patientId: _patientIdController.text,
    );

    if (result['success']) {
      Get.snackbar(
        '성공',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        duration: const Duration(seconds: 2),
      );
      Get.to(() => const LoginCompletePage());
    } else {
      Get.snackbar(
        '오류',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red[100],
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _patientIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '회원가입을 진행해주세요',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _patientIdController,
                  decoration: const InputDecoration(
                    labelText: '환자 ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 26),
                Obx(() => ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : _verifyPatient,
                      child: _authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text('가입하기'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
