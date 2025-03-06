import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/loading_page.dart';
import '../controllers/auth_controller.dart';

class LoginCompletePage extends StatelessWidget {
  const LoginCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthController 초기화
    if (!Get.isRegistered<AuthController>()) {
      //getx 에 authcontroller 의 인스턴스를 관리하고 있는지 확인하는 거임
      Get.put(AuthController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 완료'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('로그인이 완료되었습니다.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.off(() => const LoadingPage());
              },
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
