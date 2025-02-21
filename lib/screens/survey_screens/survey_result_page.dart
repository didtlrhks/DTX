import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
import 'package:dtxproject/screens/survey_screens/behavior_goals_guide_page.dart';

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
            final surveyController = Get.find<SurveyController>();
            surveyController.resetAllSurveys();
            Get.back();
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
