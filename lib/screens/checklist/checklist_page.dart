import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final List<ChecklistItem> _items = [
    ChecklistItem(title: '아침 식사하기'),
    ChecklistItem(title: '물 2L 마시기'),
    ChecklistItem(title: '30분 이상 운동하기'),
    ChecklistItem(title: '식사 기록하기'),
    ChecklistItem(title: '체중 측정하기'),
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
            child: CheckboxListTile(
              title: Text(_items[index].title),
              value: _items[index].isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  _items[index].isCompleted = value ?? false;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class ChecklistItem {
  String title;
  bool isCompleted;

  ChecklistItem({
    required this.title,
    this.isCompleted = false,
  });
}
