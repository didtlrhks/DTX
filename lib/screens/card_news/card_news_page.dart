import 'package:flutter/material.dart';

class CardNewsPage extends StatelessWidget {
  const CardNewsPage({super.key});

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
                Image.asset(
                  'assets/images/placeholder.png', // 실제 이미지로 교체 필요
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
