import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'liver_fibrosis_result_page.dart';

class LiverFibrosisPage extends StatelessWidget {
  const LiverFibrosisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('간섬유화 위험도'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '간섬유화 위험도 분석',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // 결과 페이지로 이동하는 버튼 추가
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const LiverFibrosisResultPage());
                  },
                  child: const Text('간섬유화 위험도 분석하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
