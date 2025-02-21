import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BehaviorGoalsGuidePage extends StatelessWidget {
  const BehaviorGoalsGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('행동 목표 안내'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '맞춤형 행동 목표',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '설문조사 결과를 바탕으로 귀하에게 맞는 행동 목표를 제안해드립니다.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                _buildGoalCard('식단 행동 목표', '하루 세끼 규칙적인 식사하기'),
                _buildGoalCard('운동 행동 목표', '매일 30분 이상 걷기'),
                _buildGoalCard('수면 행동 목표', '매일 같은 시간에 취침하기'),
                _buildGoalCard('음주 행동 목표', '주 2회 이하로 음주량 조절하기'),
                _buildGoalCard('감정 행동 목표', '하루 한 번 감정 일기 쓰기'),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // 다음 페이지로 이동하는 로직
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('다음'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
