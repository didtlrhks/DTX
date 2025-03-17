import 'package:dtxproject/models/lunch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/lunch_controller.dart';
import 'package:dtxproject/services/lunch_service.dart';

class LaunchPage extends StatefulWidget {
  final String? savedLunchText; // 저장된 점심 텍스트를 받을 파라미터 추가

  const LaunchPage({
    super.key,
    this.savedLunchText, // 생성자에 파라미터 추가
  });

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  // 태그 목록
  final List<String> tags = [
    '한그릇 가득',
    '반찬',
    '1/3',
    '1잔',
    '1명',
    '국물빼고',
    '1개',
    '한입',
    '한조각',
    '한봉지'
  ];

  // 선택된 태그 관리
  final RxList<String> selectedTags = <String>[].obs;

  // 텍스트 컨트롤러
  final TextEditingController textController = TextEditingController();

  // 텍스트 필드 포커스 노드
  final FocusNode focusNode = FocusNode();

  // 텍스트 입력 여부 상태
  final RxBool hasText = false.obs;

  // 텍스트 길이가 일정 이상인지 상태
  final RxBool isLongText = false.obs;

  // 최대 글자 수
  final int maxCharacters = 100;

  // 텍스트 정렬 변경 기준 글자 수
  final int alignmentChangeThreshold = 30;

  // 로딩 상태
  final RxBool isLoading = false.obs;

  // 점심 컨트롤러
  late LunchController lunchController;

  // ever 리스너를 저장할 변수 추가
  late Worker _lunchesSubscription;

  // 수정할 점심 기록 ID
  String? lunchIdToEdit;

  @override
  void initState() {
    super.initState();

    // 점심 컨트롤러 초기화
    lunchController = Get.find<LunchController>();

    // 화면이 열릴 때 최신 데이터 가져오기
    lunchController.fetchLunches();

    // lunches 리스트 변화 감지
    _lunchesSubscription =
        ever(lunchController.lunches, (List<LunchModel> lunchList) {
      if (lunchList.isNotEmpty && !disposed) {
        // 첫 번째 기록을 가져옴 (오늘 날짜의 기록일 것임)
        final todayLunch = lunchList.first;

        // ID 저장 (수정 시 사용)
        lunchIdToEdit = todayLunch.id;

        // 텍스트 설정
        textController.text = todayLunch.lunch_text;
        hasText.value = true;
        isLongText.value =
            todayLunch.lunch_text.length > alignmentChangeThreshold;

        print(
            '🔍 오늘의 점심 기록 발견: ID ${todayLunch.id}, 텍스트: ${todayLunch.lunch_text}');
      }
    });

    // 텍스트 변경 리스너 추가
    textController.addListener(() {
      hasText.value = textController.text.isNotEmpty;

      // 텍스트 길이에 따라 정렬 방식 변경
      isLongText.value = textController.text.length > alignmentChangeThreshold;

      // 최대 글자 수 제한
      if (textController.text.length > maxCharacters) {
        textController.text = textController.text.substring(0, maxCharacters);
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: maxCharacters),
        );
      }
    });

    // 포커스 리스너 추가
    focusNode.addListener(() {
      if (focusNode.hasFocus && !hasText.value) {
        // 포커스를 얻었을 때 플레이스홀더 숨기기
        hasText.value = true;
      }
    });
  }

  // disposed 플래그 추가
  bool disposed = false;

  @override
  void dispose() {
    // disposed 플래그 설정
    disposed = true;

    // ever 리스너 제거
    _lunchesSubscription.dispose();

    // 컨트롤러와 포커스 노드 해제
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // 안전하게 스낵바 표시
  void _safeShowSnackbar(String title, String message, Color backgroundColor) {
    // 기존 스낵바 닫기
    Get.closeAllSnackbars();

    // 약간의 지연 후 스낵바 표시
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.black87,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    });
  }

  // 점심 기록 저장
  Future<void> _saveLunch() async {
    final lunchText = textController.text;

    if (lunchText.isEmpty) {
      _safeShowSnackbar(
        '입력 필요',
        '점심 식사 내용을 입력해주세요.',
        Colors.red[100]!,
      );
      return;
    }

    isLoading.value = true;

    try {
      bool success;

      // 이미 오늘 기록이 있으면 업데이트, 없으면 새로 추가
      if (lunchIdToEdit != null && lunchController.lunches.isNotEmpty) {
        print('🔄 점심 기록 수정: ID $lunchIdToEdit');
        success = await lunchController.updateLunch(lunchIdToEdit!, lunchText);

        if (success) {
          _safeShowSnackbar(
            '수정 완료',
            '점심 식사 기록이 수정되었습니다.',
            Colors.green[100]!,
          );
        }
      } else {
        print('➕ 새 점심 기록 추가');
        success = await lunchController.addLunch(lunchText);

        if (success) {
          _safeShowSnackbar(
            '저장 완료',
            '점심 식사가 기록되었습니다.',
            Colors.green[100]!,
          );
        }
      }

      if (success) {
        // 점심 기록 목록을 새로고침
        await lunchController.fetchLunches();

        // 화면을 닫고 결과 반환
        Get.back(result: lunchText);
      } else {
        if (lunchController.errorMessage.value.contains('로그인')) {
          _safeShowSnackbar(
            '로그인 필요',
            '점심 식사를 기록하려면 로그인이 필요합니다.',
            Colors.red[100]!,
          );
        } else {
          _safeShowSnackbar(
            '저장 실패',
            '점심 식사 기록 중 오류가 발생했습니다: ${lunchController.errorMessage.value}',
            Colors.red[100]!,
          );
        }
      }
    } catch (e) {
      if (e.toString().contains('로그인')) {
        _safeShowSnackbar(
          '로그인 필요',
          '점심 식사를 기록하려면 로그인이 필요합니다.',
          Colors.red[100]!,
        );
      } else {
        _safeShowSnackbar(
          '오류',
          '점심 식사 기록 중 오류가 발생했습니다: $e',
          Colors.red[100]!,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '점심 기록하기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          // 삭제 버튼 (기존 기록이 있을 때만 표시)

          // 취소 버튼
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // 텍스트 필드 내용 삭제하고 취소 결과 반환
              textController.clear();
              Get.back(result: 'cancel');
              _directDelete(); // 여기서 실행이안되는데.?

              _safeShowSnackbar(
                '기록 취소',
                '점심 식사 기록이 취소되었습니다.',
                Colors.grey[300]!,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 입력 영역
                      Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: 349,
                          height: 242,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              focusNode.requestFocus();
                            },
                            child: Stack(
                              children: [
                                // 플레이스홀더 (텍스트가 없을 때만 표시)
                                Obx(() => Visibility(
                                      visible: !hasText.value,
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '점심은 뭘 드셨나요?',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '예) 라면 반그릇, 단무지 3개, 도시락 248칼로리',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                                // 텍스트 필드 - 중앙 정렬
                                Center(
                                  child: Obx(() => Container(
                                        width: isLongText.value ? 309 : 250,
                                        height: isLongText.value ? 202 : 100,
                                        alignment: isLongText.value
                                            ? Alignment.topCenter
                                            : const Alignment(
                                                0, 0.8), // 커서를 더 아래로 이동
                                        child: TextField(
                                          controller: textController,
                                          focusNode: focusNode,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '',
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 9,
                                          textAlign: isLongText.value
                                              ? TextAlign.start
                                              : TextAlign.center,
                                          textAlignVertical: isLongText.value
                                              ? TextAlignVertical.top
                                              : TextAlignVertical.center,
                                          maxLength: maxCharacters,
                                          buildCounter: (context,
                                                  {required currentLength,
                                                  required isFocused,
                                                  maxLength}) =>
                                              null,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 태그 버튼들
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children: tags.map((tag) {
                            return GestureDetector(
                              onTap: () {
                                // 태그 텍스트를 현재 커서 위치에 삽입
                                final currentText = textController.text;
                                final selection = textController.selection;

                                // 최대 글자 수 체크
                                if (currentText.length + tag.length >
                                    maxCharacters) {
                                  _safeShowSnackbar(
                                    '글자 수 제한',
                                    '최대 글자 수를 초과했습니다.',
                                    Colors.red[100]!,
                                  );
                                  return;
                                }

                                // 현재 커서 위치 또는 텍스트 끝에 태그 삽입
                                final newText = selection.isValid
                                    ? currentText.substring(
                                            0, selection.start) +
                                        tag +
                                        currentText.substring(selection.end)
                                    : currentText + tag;

                                // 새 커서 위치 계산
                                final newCursorPosition = selection.isValid
                                    ? selection.start + tag.length
                                    : newText.length;

                                // 텍스트 업데이트
                                textController.value = TextEditingValue(
                                  text: newText,
                                  selection: TextSelection.collapsed(
                                    offset: newCursorPosition,
                                  ),
                                );

                                // 포커스 유지
                                focusNode.requestFocus();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 하단 버튼 영역
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.closeAllSnackbars();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 56,
                        margin: const EdgeInsets.only(left: 8),
                        child: Obx(() => ElevatedButton(
                              onPressed: isLoading.value ? null : _saveLunch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor: Colors.grey[400],
                                disabledForegroundColor: Colors.white70,
                              ),
                              child: isLoading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      '저장',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 로딩 인디케이터
          Obx(() => isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  // 직접 삭제 실행 (다이얼로그 없이)
  void _directDelete() async {
    if (lunchIdToEdit == null) {
      print('❌ 삭제 실패: lunchIdToEdit가 null입니다.');
      _safeShowSnackbar(
        '오류',
        '삭제할 점심 기록이 없습니다.',
        Colors.red[100]!,
      );
      return;
    }

    print('🗑️ 점심 기록 직접 삭제 시작: ID $lunchIdToEdit');
    isLoading.value = true;

    try {
      final lunchService = Get.find<LunchService>();
      await lunchService.deleteLunch(lunchIdToEdit!);

      print('✅ 점심 기록 삭제 성공');
      _safeShowSnackbar(
        '삭제 완료',
        '점심 식사 기록이 삭제되었습니다.',
        Colors.green[100]!,
      );

      // 화면을 닫고 삭제 결과 반환
      Get.back(result: 'deleted');
    } catch (e) {
      print('❌ 점심 기록 삭제 오류: $e');
      _safeShowSnackbar(
        '삭제 실패',
        '점심 식사 기록을 삭제하는 중 오류가 발생했습니다.',
        Colors.red[100]!,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
