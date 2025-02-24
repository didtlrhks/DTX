import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
import 'package:dtxproject/screens/behavior_goals/behavior_goals_guide_page.dart';

class SurveyResultPage extends StatelessWidget {
  const SurveyResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설문조사 결과'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text('설문조사 나가기'),
                content: const Text('설문조사를 종료하시겠습니까?\n모든 응답이 초기화됩니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // 다이얼로그 닫기
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      final surveyController = Get.find<SurveyController>();
                      surveyController.resetAllSurveys();
                      Get.back(); // 다이얼로그 닫기
                      Get.back(); // 이전 페이지로 이동
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '설문조사 결과 분석',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '설문조사 결과가 분석되었습니다.\n추후 상세한 분석 결과가 제공될 예정입니다.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const BehaviorGoalsGuidePage());
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('다음'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
