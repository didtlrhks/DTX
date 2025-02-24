import 'package:flutter/material.dart';

class CardNewsPage extends StatelessWidget {
  const CardNewsPage({super.key});

  // 랜덤한 색상 리스트 생성
  final List<Color> _mockColors = const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강 카드뉴스'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // 예시로 10개의 카드뉴스
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: _mockColors[index], // 색상 배열에서 색상 선택
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '카드뉴스 제목 ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '카드뉴스 내용 ${index + 1}의 간단한 설명이 들어갑니다.',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
