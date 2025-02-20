import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/liver_fibrosis_page.dart';

class LoginCompletePage extends StatelessWidget {
  const LoginCompletePage({super.key});

  void _showLoadingAndNavigate() async {
    // 로딩 다이얼로그 표시
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    // 3초 대기
    await Future.delayed(const Duration(seconds: 3));

    // 로딩 다이얼로그 닫기
    Get.back();

    // 간섬유화 위험도 페이지로 이동 (이전 페이지들 모두 삭제)
    Get.offAll(() => const LiverFibrosisPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              const Text(
                '로그인 완료',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _showLoadingAndNavigate,
                child: const Text('시작하기'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // 문의하기 버튼 클릭 시 동작
                },
                child: const Text('문의하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
