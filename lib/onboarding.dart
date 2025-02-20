import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '환영합니다!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('온보딩 페이지입니다'),
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text('시작하기'),
              onPressed: () {
                Get.off(() => const HomePage()); // HomePage로 이동 (뒤로가기 불가)
              },
            ),
          ],
        ),
      ),
    );
  }
}
