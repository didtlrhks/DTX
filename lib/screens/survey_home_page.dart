import 'package:flutter/material.dart';

class SurveyHomePage extends StatelessWidget {
  const SurveyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설문조사'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '건강 설문조사',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '이 설문조사는 귀하의 건강 상태를 더 자세히 파악하기 위한 것입니다. 약 5-10분 정도 소요됩니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                child: ListTile(
                  title: const Text('기본 건강 설문'),
                  subtitle: const Text('일반적인 건강 상태 체크'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: 기본 건강 설문 페이지로 이동
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('생활습관 설문'),
                  subtitle: const Text('일상적인 생활습관 체크'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: 생활습관 설문 페이지로 이동
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('식습관 설문'),
                  subtitle: const Text('평소 식습관 체크'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: 식습관 설문 페이지로 이동
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
