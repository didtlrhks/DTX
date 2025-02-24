import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/screens/settings/settings_page.dart';
import 'package:dtxproject/screens/card_news/card_news_page.dart';
import 'package:dtxproject/screens/input/weight_input_page.dart';
import 'package:dtxproject/screens/input/diet_input_page.dart';
import 'package:dtxproject/screens/input/exercise_input_page.dart';
import 'package:dtxproject/screens/behavior_goals/behavior_goals_onboarding_page.dart';

class HomePage extends StatelessWidget {
  final String? goalTitle;
  final String? goalContent;

  const HomePage({
    super.key,
    this.goalTitle,
    this.goalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '안녕하세요!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Get.to(() => const SettingsPage());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 카드뉴스 섹션
                SizedBox(
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '오늘의 건강 컨텐츠',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: PageView.builder(
                              itemCount: 3, // 예시로 3개의 카드뉴스
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => const CardNewsPage());
                                  },
                                  child: Card(
                                    child: Center(
                                      child: Text('카드뉴스 ${index + 1}'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 대시보드 섹션
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '오늘의 대시보드',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateTime.now().toString().substring(0, 10),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 결과 목표 & 행동 목표
                        if (goalTitle != null && goalTitle!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('현재 진행중인 목표'),
                              Text(goalTitle!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              if (goalContent != null) Text(goalContent!),
                              const SizedBox(height: 16),
                            ],
                          ),

                        // 입력 섹션들
                        _buildInputSection(
                          icon: Icons.monitor_weight,
                          title: '체중 입력',
                          onTap: () {
                            Get.to(() => const WeightInputPage());
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildInputSection(
                          icon: Icons.restaurant,
                          title: '식단 입력',
                          onTap: () {
                            Get.to(() => const DietInputPage());
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildInputSection(
                          icon: Icons.fitness_center,
                          title: '운동 입력',
                          onTap: () {
                            Get.to(() => const ExerciseInputPage());
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 기존 카드들
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.track_changes),
                    title: const Text('행동 목표'),
                    subtitle: const Text('나의 행동 목표를 설정하고 관리하세요'),
                    onTap: () {
                      Get.to(() => const BehaviorGoalsOnboardingPage());
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.checklist),
                    title: const Text('체크리스트'),
                    subtitle: const Text('오늘의 할 일을 체크하세요'),
                    onTap: () {
                      Navigator.pushNamed(context, '/checklist');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
