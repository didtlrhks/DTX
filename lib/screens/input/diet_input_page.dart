import 'package:flutter/material.dart';

class DietInputPage extends StatelessWidget {
  const DietInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식단 입력'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMealSection('아침'),
          const SizedBox(height: 16),
          _buildMealSection('점심'),
          const SizedBox(height: 16),
          _buildMealSection('저녁'),
          const SizedBox(height: 16),
          _buildMealSection('간식'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // 식단 저장 로직
              Navigator.pop(context);
            },
            child: const Text('저장하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(String mealTime) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealTime,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '$mealTime 메뉴를 입력하세요',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
