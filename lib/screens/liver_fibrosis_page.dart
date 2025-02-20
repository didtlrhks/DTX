import 'package:flutter/material.dart';

class LiverFibrosisPage extends StatelessWidget {
  const LiverFibrosisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('간섬유화 위험도'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '간섬유화 위험도 분석',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // 여기에 간섬유화 위험도 관련 내용을 추가하시면 됩니다
            ],
          ),
        ),
      ),
    );
  }
}
