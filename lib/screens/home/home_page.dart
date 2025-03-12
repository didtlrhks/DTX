import 'package:dtxproject/screens/input/breakfast_page.dart';
import 'package:dtxproject/screens/input/daily_review.dart';
import 'package:dtxproject/screens/input/dinner_page.dart';
import 'package:dtxproject/screens/input/exercise_input_page.dart';
import 'package:dtxproject/screens/input/launch_page.dart';
import 'package:dtxproject/screens/input/snack_page.dart';
import 'package:dtxproject/screens/input/weight_input_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:dtxproject/controllers/auth_controller.dart';
import 'package:dtxproject/utils/date_utils.dart';
// SharedPreferences 대신 메모리 저장소 사용
// import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:convert';

// 미션 아이템 ID 상수 정의
class MissionIds {
  static const int breakfast = 1;
  static const int lunch = 2;
  static const int dinner = 3;
  static const int snack = 4;
  static const int exercise = 5;
  static const int dailyReview = 6;
  static const int weight = 7;
}

// 미션 데이터 저장소 인터페이스 - 나중에 서버 저장소로 교체 가능
abstract class MissionStorage {
  Future<void> saveMissions(
      List<int> completedMissions, List<int> missionOrder, String date);
  Future<Map<String, dynamic>?> loadMissions();
  Future<void> clearMissions();
}

// 메모리 기반 임시 저장소 구현 (SharedPreferences 대신 사용)
class MemoryMissionStorage implements MissionStorage {
  // 싱글톤 패턴
  static final MemoryMissionStorage _instance =
      MemoryMissionStorage._internal();
  factory MemoryMissionStorage() => _instance;
  MemoryMissionStorage._internal();

  // 메모리 저장소
  Map<String, dynamic>? _data;

  @override
  Future<void> saveMissions(
      List<int> completedMissions, List<int> missionOrder, String date) async {
    _data = {
      'completedMissions': completedMissions,
      'missionOrder': missionOrder,
      'missionDate': date,
    };
  }

  @override
  Future<Map<String, dynamic>?> loadMissions() async {
    return _data;
  }

  @override
  Future<void> clearMissions() async {
    _data = null;
  }
}

// 나중에 서버 저장소로 교체할 때 구현할 클래스
// class ServerMissionStorage implements MissionStorage {
//   @override
//   Future<void> saveMissions(List<int> completedMissions, List<int> missionOrder, String date) async {
//     // API 호출로 서버에 저장
//   }
//
//   @override
//   Future<Map<String, dynamic>?> loadMissions() async {
//     // API 호출로 서버에서 불러오기
//   }
//
//   @override
//   Future<void> clearMissions() async {
//     // API 호출로 서버에서 삭제
//   }
// }

// 미션 컨트롤러 추가
class MissionController extends GetxController {
  // 완료된 미션 ID 목록
  final RxList<int> completedMissions = <int>[].obs;

  // 미션 순서 (기본 순서)
  final RxList<int> missionOrder = <int>[
    MissionIds.breakfast,
    MissionIds.lunch,
    MissionIds.dinner,
    MissionIds.snack,
    MissionIds.exercise,
    MissionIds.dailyReview,
    MissionIds.weight,
  ].obs;

  // 원래 미션 순서
  final List<int> originalOrder = [
    MissionIds.breakfast,
    MissionIds.lunch,
    MissionIds.dinner,
    MissionIds.snack,
    MissionIds.exercise,
    MissionIds.dailyReview,
    MissionIds.weight,
  ];

  // 미션 저장소
  final MissionStorage _storage = MemoryMissionStorage();
  // 서버 저장소로 변경할 때는 아래 줄의 주석을 해제하고 위 줄을 주석 처리
  // final MissionStorage _storage = ServerMissionStorage();

  @override
  void onInit() {
    super.onInit();
    // 저장된 미션 상태 불러오기
    loadMissionState();
  }

  // 미션 완료 처리
  void completeMission(int missionId) {
    // 이미 완료된 미션이 아니라면 추가
    if (!completedMissions.contains(missionId)) {
      completedMissions.add(missionId);

      // 미션 순서 재배치 (완료된 미션을 맨 아래로)
      missionOrder.remove(missionId);
      missionOrder.add(missionId);

      // 미션 상태 저장
      saveMissionState();
    }
  }

  // 미션 취소 처리
  void cancelMission(int missionId) {
    // 완료된 미션 목록에서 제거
    completedMissions.remove(missionId);

    // 미션 순서 재배치 (원래 순서로 돌아가기)
    missionOrder.remove(missionId);

    // 원래 순서에서의 위치 찾기
    int originalIndex = originalOrder.indexOf(missionId);

    // 현재 missionOrder에서 originalIndex보다 작은 인덱스를 가진 미션들의 수 계산
    int insertIndex = 0;
    for (int i = 0; i < originalIndex; i++) {
      if (missionOrder.contains(originalOrder[i])) {
        insertIndex++;
      }
    }

    // 적절한 위치에 미션 삽입
    if (insertIndex >= missionOrder.length) {
      missionOrder.add(missionId);
    } else {
      missionOrder.insert(insertIndex, missionId);
    }

    // 미션 상태 저장
    saveMissionState();
  }

  // 미션 완료 여부 확인
  bool isMissionCompleted(int missionId) {
    return completedMissions.contains(missionId);
  }

  // 미션 상태 저장
  Future<void> saveMissionState() async {
    try {
      // 현재 날짜 가져오기
      final currentDate = DateUtil.getCurrentDateInfo()['fullDate'] ?? '';

      // 저장소에 저장
      await _storage.saveMissions(
          completedMissions.toList(), missionOrder.toList(), currentDate);
    } catch (e) {
      print('미션 상태 저장 오류: $e');
    }
  }

  // 미션 상태 불러오기
  Future<void> loadMissionState() async {
    try {
      // 저장소에서 불러오기
      final data = await _storage.loadMissions();

      // 데이터가 없으면 초기화
      if (data == null) {
        resetMissionState();
        return;
      }

      // 저장된 날짜 확인
      final savedDate = data['missionDate'] ?? '';
      final currentDate = DateUtil.getCurrentDateInfo()['fullDate'] ?? '';

      // 날짜가 바뀌었으면 미션 초기화
      if (savedDate != currentDate) {
        resetMissionState();
        return;
      }

      // 완료된 미션 ID 목록 불러오기
      final List<dynamic>? completedMissionsData = data['completedMissions'];
      if (completedMissionsData != null) {
        completedMissions.value =
            completedMissionsData.map((e) => e as int).toList();
      }

      // 미션 순서 불러오기
      final List<dynamic>? missionOrderData = data['missionOrder'];
      if (missionOrderData != null) {
        missionOrder.value = missionOrderData.map((e) => e as int).toList();
      }
    } catch (e) {
      print('미션 상태 불러오기 오류: $e');
      resetMissionState();
    }
  }

  // 미션 상태 초기화
  void resetMissionState() {
    completedMissions.clear();
    missionOrder.value = List.from(originalOrder);
    saveMissionState();
  }
}

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
    // 미션 컨트롤러 등록
    final MissionController missionController = Get.put(MissionController());

    final dateInfo = DateUtil.getCurrentDateInfo();
    final day = dateInfo['day']!;
    final weekday = dateInfo['weekday']!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20),
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
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 17, bottom: 17),
                        child: Row(
                          children: [
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
                                      '목표체중',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 2),
                      Row(
                        children: [
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
                                Text(
                                  day,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  weekday,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 2),
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
                      const SizedBox(height: 66),
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            7,
                            (index) => Container(
                              width: 20,
                              height: 2,
                              color: Colors.brown[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF707070),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  '매일 미션',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 148,
                              height: 47,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat_bubble_outline,
                                    size: 16),
                                label: const Text('채팅상담'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0x00707070),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  textStyle: const TextStyle(fontSize: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(() => SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildMissionItems(missionController),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 미션 아이템 목록 생성
  List<Widget> _buildMissionItems(MissionController controller) {
    final List<Widget> items = [];
    final missionOrder = controller.missionOrder;

    for (int i = 0; i < missionOrder.length; i++) {
      final missionId = missionOrder[i];
      final isFirst = i == 0;
      final isLast = i == missionOrder.length - 1;

      String title;
      switch (missionId) {
        case MissionIds.breakfast:
          title = '아침 기록';
          break;
        case MissionIds.lunch:
          title = '점심 기록';
          break;
        case MissionIds.dinner:
          title = '저녁 기록';
          break;
        case MissionIds.snack:
          title = '간식/야식 기록';
          break;
        case MissionIds.exercise:
          title = '운동 기록';
          break;
        case MissionIds.dailyReview:
          title = '오늘 하루 별점리뷰';
          break;
        case MissionIds.weight:
          title = '체중 기록';
          break;
        default:
          title = '미션';
      }

      items.add(
        Padding(
          padding: EdgeInsets.only(top: isFirst ? 0 : 0),
          child: _buildTimelineMissionItem(
            title,
            missionId,
            isFirst,
            isLast,
            controller.isMissionCompleted(missionId),
          ),
        ),
      );
    }

    items.add(const SizedBox(height: 16));
    return items;
  }

  Widget _buildTimelineMissionItem(String title, int missionId, bool isFirst,
      bool isLast, bool isCompleted) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      alignment: TimelineAlign.manual,
      lineXY: 0.02,
      indicatorStyle: IndicatorStyle(
        width: 8,
        height: 8,
        indicator: Container(
          decoration: BoxDecoration(
            color:
                isCompleted ? const Color(0xFF707070) : const Color(0xFF707070),
            shape: BoxShape.circle,
          ),
        ),
        padding: const EdgeInsets.all(2),
        drawGap: true,
      ),
      beforeLineStyle: const LineStyle(
        color: Color(0xFFD3D3D3),
        thickness: 2,
      ),
      afterLineStyle: const LineStyle(
        color: Color(0xFFD3D3D3),
        thickness: 2,
      ),
      startChild: const SizedBox(
        width: 100,
      ),
      endChild: Container(
        constraints: const BoxConstraints(
          minHeight: 85,
        ),
        padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
        child: GestureDetector(
          onTap: () {
            _navigateToMissionPage(missionId);
          },
          child: Container(
            width: double.infinity,
            height: 77,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF707070)
                  : const Color(0xFFE0E0E0),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? Colors.white : Colors.black,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.transparent,
                    child: isCompleted
                        ? Image.asset(
                            'assets/images/check_circle_bold.png',
                            width: 20,
                            height: 20,
                          )
                        : const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 미션 ID에 따라 적절한 페이지로 이동하는 메서드
  void _navigateToMissionPage(int missionId) {
    switch (missionId) {
      case MissionIds.breakfast:
        Get.to(() => const BreakfastPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 아침 식사 기록 취소 처리
              controller.cancelMission(MissionIds.breakfast);
            } else {
              // 아침 식사 기록 완료 처리
              controller.completeMission(MissionIds.breakfast);
            }
          }
        });
        break;
      case MissionIds.lunch:
        Get.to(() => const LaunchPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 점심 식사 기록 취소 처리
              controller.cancelMission(MissionIds.lunch);
            } else {
              // 점심 식사 기록 완료 처리
              controller.completeMission(MissionIds.lunch);
            }
          }
        });
        break;
      case MissionIds.dinner:
        Get.to(() => const DinnerPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 저녁 식사 기록 취소 처리
              controller.cancelMission(MissionIds.dinner);
            } else {
              // 저녁 식사 기록 완료 처리
              controller.completeMission(MissionIds.dinner);
            }
          }
        });
        break;
      case MissionIds.snack:
        Get.to(() => const SnackPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 간식 기록 취소 처리
              controller.cancelMission(MissionIds.snack);
            } else {
              // 간식 기록 완료 처리
              controller.completeMission(MissionIds.snack);
            }
          }
        });
        break;
      case MissionIds.exercise:
        Get.to(() => const ExerciseInputPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 운동 기록 취소 처리
              controller.cancelMission(MissionIds.exercise);
            } else {
              // 운동 기록 완료 처리
              controller.completeMission(MissionIds.exercise);
            }
          }
        });
        break;
      case MissionIds.dailyReview:
        Get.to(() => DailyReviewPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 일일 리뷰 취소 처리
              controller.cancelMission(MissionIds.dailyReview);
            } else {
              // 일일 리뷰 완료 처리
              controller.completeMission(MissionIds.dailyReview);
            }
          }
        });
        break;
      case MissionIds.weight:
        Get.to(() => WeightPage())?.then((result) {
          if (result != null) {
            final controller = Get.find<MissionController>();
            if (result == 'cancel') {
              // 체중 기록 취소 처리
              controller.cancelMission(MissionIds.weight);
            } else {
              // 체중 기록 완료 처리
              controller.completeMission(MissionIds.weight);
            }
          }
        });
        break;
      default:
        break;
    }
  }
}
