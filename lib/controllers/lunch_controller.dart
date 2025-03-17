import 'package:get/get.dart';
import '../models/lunch_model.dart';
import '../services/lunch_service.dart';
import '../controllers/auth_controller.dart';

class LunchController extends GetxController {
  final LunchService _lunchService;
  final AuthController _authController = Get.find<AuthController>();

  // 점심 기록 목록
  final RxList<LunchModel> lunches = <LunchModel>[].obs;

  // 로딩 상태
  final RxBool isLoading = false.obs;

  // 에러 메시지
  final RxString errorMessage = ''.obs;

  // 로그인 상태
  final RxBool isLoggedIn = false.obs;

  // 생성자
  LunchController({required LunchService lunchService})
      : _lunchService = lunchService;

  @override
  void onInit() {
    super.onInit();

    // 사용자 정보 변경 감지
    ever(_authController.user, (user) {
      if (user != null && user.id != null) {
        _lunchService.setUserId(user.id!);
        isLoggedIn.value = true;
        print('사용자 ID 설정됨: ${user.id}');
        fetchLunches(); // 로그인 상태가 변경될 때 점심 기록 가져오기
      } else {
        isLoggedIn.value = false;
        print('로그인된 사용자 정보 없음');
      }
    });

    // 초기 상태 설정
    if (_authController.user.value != null &&
        _authController.user.value!.id != null) {
      _lunchService.setUserId(_authController.user.value!.id!);
      isLoggedIn.value = true;
      fetchLunches();
    }
  }

  // 점심 기록 목록 가져오기
  Future<void> fetchLunches() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('점심 기록 조회 시작...');
      final fetchedLunches = await _lunchService.getLunches();
      print('조회된 점심 기록 수: ${fetchedLunches.length}');

      // 조회된 데이터 설정
      lunches.value = fetchedLunches;

      // 디버깅을 위해 조회된 데이터 출력
      if (fetchedLunches.isNotEmpty) {
        print('첫 번째 점심 기록: ${fetchedLunches[0].lunch_text}');
      } else {
        print('조회된 점심 기록이 없습니다.');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('점심 기록 조회 오류: $e');
      // 오류 발생 시 빈 목록으로 초기화
      lunches.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // 점심 기록 추가
  Future<bool> addLunch(String text) async {
    if (!isLoggedIn.value) {
      errorMessage.value = '로그인이 필요합니다.';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final addedLunch = await _lunchService.addLunch(text);
      lunches.add(addedLunch);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('점심 기록 추가 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 점심 기록 삭제
  Future<bool> deleteLunch(String id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('점심 기록 삭제 시작: ID $id');

      // 서버에 삭제 요청
      await _lunchService.deleteLunch(id);

      // 로컬 상태 업데이트
      lunches.removeWhere((lunch) => lunch.id == id);

      print('점심 기록 삭제 완료');
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('점심 기록 삭제 오류: $e');

      // 오류가 발생해도 UI에서는 삭제된 것처럼 처리 (사용자 경험 개선)
      lunches.removeWhere((lunch) => lunch.id == id);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 점심 기록 수정
  Future<bool> updateLunch(String id, String text) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _lunchService.updateLunch(id, text);

      // 성공적으로 수정된 경우 lunches 리스트 업데이트
      await fetchLunches();

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ 점심 기록 수정 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
