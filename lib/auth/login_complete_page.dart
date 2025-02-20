import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginCompletePage extends StatelessWidget {
  const LoginCompletePage({super.key});

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
                onPressed: () {
                  // 시작하기 버튼 클릭 시 동작
                },
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
