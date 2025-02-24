import 'package:flutter/material.dart';

class ExerciseInputPage extends StatelessWidget {
  const ExerciseInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildExerciseInput('걷기'),
                  const SizedBox(height: 16),
                  _buildExerciseInput('달리기'),
                  const SizedBox(height: 16),
                  _buildExerciseInput('자전거'),
                  const SizedBox(height: 16),
                  _buildExerciseInput('수영'),
                  const SizedBox(height: 16),
                  _buildExerciseInput('근력 운동'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 운동 기록 저장 로직
                Navigator.pop(context);
              },
              child: const Text('저장하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInput(String exerciseType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exerciseType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '시간 (분)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '강도 (1-5)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
