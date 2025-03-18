import 'package:get/get.dart';

import 'package:dtxproject/utils/date_utils.dart';

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
