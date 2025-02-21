import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';

class SurveyResultPage extends StatelessWidget {
  const SurveyResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설문조사 결과'),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '설문조사 결과 분석',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // 여기에 결과 내용을 추가할 수 있습니다
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '설문조사 결과가 분석되었습니다.\n추후 상세한 분석 결과가 제공될 예정입니다.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
