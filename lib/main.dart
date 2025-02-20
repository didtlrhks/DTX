import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      // GetMaterialApp 사용
      title: 'GetX 네비게이션 예시',
      home: OnboardingPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 페이지'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('두 번째 페이지로 이동'),
          onPressed: () {
            // GetX 네비게이션 사용
            Get.to(() => const SecondPage());
          },
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('두 번째 페이지'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('두 번째 페이지입니다'),
            ElevatedButton(
              child: const Text('뒤로 가기'),
              onPressed: () {
                Get.back(); // 이전 페이지로 돌아가기
              },
            ),
          ],
        ),
      ),
    );
  }
}
