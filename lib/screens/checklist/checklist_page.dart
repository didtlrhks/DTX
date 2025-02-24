import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final List<ChecklistItem> _items = [
    ChecklistItem(title: '식이 체크', description: '오늘의 식사는 어땠나요?'),
    ChecklistItem(title: '활동량 체크', description: '오늘의 운동량은 어땠나요?'),
    ChecklistItem(title: '음주 체크', description: '오늘의 음주량은 어땠나요?'),
    ChecklistItem(title: '수면 체크', description: '오늘의 수면은 어땠나요?'),
    ChecklistItem(title: '감정 체크', description: '오늘의 감정 상태는 어땠나요?'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 체크리스트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _items[index].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _items[index].description,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('0'),
                      Expanded(
                        child: Slider(
                          value: _items[index].score,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _items[index].score.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _items[index].score = value;
                            });
                          },
                        ),
                      ),
                      const Text('10'),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${_items[index].score.round()}/10점',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChecklistItem {
  String title;
  String description;
  double score;

  ChecklistItem({
    required this.title,
    required this.description,
    this.score = 5,
  });
}
