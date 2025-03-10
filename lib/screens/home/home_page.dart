import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/screens/settings/settings_page.dart';
import 'package:dtxproject/screens/card_news/card_news_page.dart';
import 'package:dtxproject/screens/input/weight_input_page.dart';
import 'package:dtxproject/screens/input/diet_input_page.dart';
import 'package:dtxproject/screens/input/exercise_input_page.dart';
import 'package:dtxproject/screens/behavior_goals/behavior_goals_onboarding_page.dart';
import 'package:dtxproject/screens/checklist/checklist_page.dart';
import 'package:dtxproject/controllers/auth_controller.dart';

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
    final AuthController authController = Get.find<AuthController>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null, // 앱바 제거
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 흰색 배경 영역
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 사용자 이름 (오른쪽 상단)
                  SizedBox(height: MediaQuery.of(context).padding.top + 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '부민병원, ${authController.user.value?.username ?? "사용자"}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(Icons.person,
                                    size: 16, color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 점수 표시 영역
                        Padding(
                          padding: const EdgeInsets.only(top: 17, bottom: 17),
                          child: Row(
                            children: [
                              // 왼쪽 원형 점수 (71x71)
                              Container(
                                width: 71,
                                height: 71,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 2),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '85',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '포인트',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // 오른쪽 운동 시간 카드 (261x77)
                              Container(
                                width: 261,
                                height: 77,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '오늘 목표 / 누적',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '하루 30분 걷기',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 날짜 및 카드 뉴스 영역
                        const SizedBox(height: 2),

                        Row(
                          children: [
                            // 날짜 표시
                            Container(
                              width: 52,
                              height: 77,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '오늘',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const Text(
                                    '07',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '화요일',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // 카드 뉴스 영역
                            Container(
                              width: 80,
                              height: 77,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '카드',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '뉴스',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        // 모아보기 버튼
                        Container(
                          width: 134,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              '모아보기',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        // 식물 일러스트 영역
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    index % 2 == 0 ? Icons.spa : Icons.grass,
                                    color: Colors.green,
                                    size: 24 + (index % 3) * 4,
                                  ),
                                  Container(
                                    width: 20,
                                    height: 2,
                                    color: Colors.brown[300],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 하단 회색 배경 영역 (꽃 아래부터)
            Container(
              color: Colors.grey[100],
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // 미션 섹션
                    Column(
                      children: [
                        // 미션 헤더
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '매일 미션',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeColor: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),

                        // 미션 아이템들
                        _buildMissionItem('아침 기록', true),
                        _buildMissionItem('점심 기록', true),
                        _buildMissionItem('저녁 기록', true),
                        _buildMissionItem('간식/야식 기록', true),
                        _buildMissionItem('운동 기록', false),
                        _buildMissionItem('오늘 하루 별점리뷰', false),
                        _buildMissionItem('체중 기록', false),

                        const SizedBox(height: 16),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionItem(String title, bool hasSwitch) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.black),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (hasSwitch)
              Row(
                children: [
                  const Text(
                    '완료',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Colors.grey[600],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
