import 'package:flutter/material.dart';

class WeightInputPage extends StatefulWidget {
  const WeightInputPage({super.key});

  @override
  State<WeightInputPage> createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('체중 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '오늘의 체중을 입력해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '체중 (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 체중 저장 로직
                  Navigator.pop(context);
                },
                child: const Text('저장하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}
