import 'package:get/get.dart';
import '../models/breakfast_model.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../services/breakfast_service.dart';

class BreakfastController extends GetxController {
  final BreakfastService _breakfastService;
  final AuthController _authController = Get.find<AuthController>();

  // 점심 기록 목록
  final RxList<BreakfastModel> breakfasts = <BreakfastModel>[].obs;

  // 로딩 상태
  final RxBool isLoading = false.obs;

  // 에러 메시지
  final RxString errorMessage = ''.obs;

  // 로그인 상태
  final RxBool isLoggedIn = false.obs;

  // 오늘의 점심 기록 ID (있는 경우)
  final Rx<String?> todayLunchId = Rx<String?>(null);

  // 텍스트 입력 관련 상태
  final RxBool hasText = false.obs;
  final RxBool isLongText = false.obs;

  // 생성자
  BreakfastController({required BreakfastService breakfastService})
      : _breakfastService = breakfastService;

  @override
  void onInit() {
    super.onInit();

    // 사용자 정보 변경 감지
    ever(_authController.user, (user) {
      if (user != null && user.id != null) {
        _breakfastService.setUserId(user.id!);
        isLoggedIn.value = true;
        print('사용자 ID 설정됨: ${user.id}');
        fetchBreakfasts(); // 로그인 상태가 변경될 때 점심 기록 가져오기
      } else {
        isLoggedIn.value = false;
        print('로그인된 사용자 정보 없음');
      }
    });

    // 초기 상태 설정
    if (_authController.user.value != null &&
        _authController.user.value!.id != null) {
      _breakfastService.setUserId(_authController.user.value!.id!);
      isLoggedIn.value = true;
      fetchBreakfasts();
    }
  }

  // 점심 기록 목록 가져오기
  Future<void> fetchBreakfasts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('점심 기록 조회 시작...');
      final fetchedBreakfasts = await _breakfastService.getBreakfasts();
      print('조회된 점심 기록 수: ${fetchedBreakfasts.length}');

      // 조회된 데이터 설정
      breakfasts.value = fetchedBreakfasts;

      // 디버깅을 위해 조회된 데이터 출력
      if (fetchedBreakfasts.isNotEmpty) {
        print('첫 번째 점심 기록: ${fetchedBreakfasts[0].breakfast_text}');
      } else {
        print('조회된 점심 기록이 없습니다.');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('점심 기록 조회 오류: $e');
      // 오류 발생 시 빈 목록으로 초기화
      breakfasts.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // 아침 기록 추가
  Future<bool> addBreakfast(String text) async {
    if (!isLoggedIn.value) {
      errorMessage.value = '로그인이 필요합니다.';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final addedBreakfast = await _breakfastService.addBreakfast(text);
      breakfasts.add(addedBreakfast);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('아침 기록 추가 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 아침 기록 삭제
  Future<bool> deleteBreakfast(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🗑️ BreakfastController: 아침 기록 삭제 시작: ID $id');
      print('삭제 전 breakfasts 목록 길이: ${breakfasts.length}');

      // 삭제할 기록이 목록에 있는지 확인
      final breakfastToDelete =
          breakfasts.firstWhereOrNull((breakfast) => breakfast.id == id);
      if (breakfastToDelete != null) {
        print('삭제할 기록 찾음: ${breakfastToDelete.breakfast_text}');
      } else {
        print('⚠️ 삭제할 기록을 breakfasts 목록에서 찾을 수 없음');
      }

      // BreakfastService의 deleteBreakfast 메서드 호출
      print('BreakfastService.deleteBreakfast 호출 전');
      await _breakfastService.deleteBreakfast(id);
      print('BreakfastService.deleteBreakfast 호출 후');

      // 성공적으로 삭제된 경우 breakfasts 리스트에서 해당 항목 제거
      final removedCount = breakfasts.length;
      breakfasts.removeWhere((breakfast) => breakfast.id == id);
      final afterRemoveCount = breakfasts.length;

      print(
          '삭제 후 breakfasts 목록 길이: $afterRemoveCount (제거된 항목: ${removedCount - afterRemoveCount})');
      breakfasts.refresh(); // GetX 리스트 갱신

      print('✅ 아침 기록 삭제 완료: ID $id');
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ 아침 기록 삭제 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 아침 기록 수정
  Future<bool> updateBreakfast(String id, String text) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _breakfastService.updateBreakfast(id, text);

      // 성공적으로 수정된 경우 breakfasts 리스트 업데이트
      await fetchBreakfasts();

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ 아침 기록 수정 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 텍스트 길이 체크 및 상태 업데이트
  void updateTextState(String text, int threshold) {
    hasText.value = text.isNotEmpty;
    isLongText.value = text.length > threshold;
  }

  // 텍스트 최대 길이 체크 및 처리
  String enforceMaxLength(
      String text, int maxLength, TextEditingController controller) {
    if (text.length > maxLength) {
      final truncated = text.substring(0, maxLength);
      controller.text = truncated;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: maxLength),
      );
      return truncated;
    }
    return text;
  }

  // 태그 텍스트 삽입
  void insertTag(String tag, TextEditingController controller, int maxLength) {
    final currentText = controller.text;
    final selection = controller.selection;

    // 최대 글자 수 체크
    if (currentText.length + tag.length > maxLength) {
      errorMessage.value = '최대 글자 수를 초과했습니다.';
      return;
    }

    // 현재 커서 위치 또는 텍스트 끝에 태그 삽입
    final newText = selection.isValid
        ? currentText.substring(0, selection.start) +
            tag +
            currentText.substring(selection.end)
        : currentText + tag;

    // 새 커서 위치 계산
    final newCursorPosition =
        selection.isValid ? selection.start + tag.length : newText.length;

    // 텍스트 업데이트
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );

    // 상태 업데이트
    updateTextState(newText, 30); // 30은 alignmentChangeThreshold 값
  }

  // 아침 기록 저장 또는 수정 (오늘 기록이 있으면 수정, 없으면 추가)
  Future<bool> saveOrUpdateBreakfast(String text) async {
    if (text.isEmpty) {
      errorMessage.value = '아침 식사 내용을 입력해주세요.';
      return false;
    }

    try {
      bool success;

      // 오늘 기록이 있는지 확인 (breakfasts가 비어있지 않고 첫 번째 항목이 오늘 날짜인 경우)
      if (breakfasts.isNotEmpty) {
        final todayBreakfast = breakfasts.first;

        // null 체크 추가
        if (todayBreakfast.id != null) {
          success = await updateBreakfast(todayBreakfast.id!, text);
        } else {
          // id가 null인 경우 새로 추가
          success = await addBreakfast(text);
        }
      } else {
        success = await addBreakfast(text);
      }

      return success;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }
}
