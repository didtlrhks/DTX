import 'package:dtxproject/models/breakfast_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/breakfast_controller.dart';
import 'package:dtxproject/services/breakfast_service.dart';

class BreakfastPage extends StatefulWidget {
  final String? savedBreakfastText;

  const BreakfastPage({
    super.key,
    this.savedBreakfastText,
  });

  @override
  State<BreakfastPage> createState() => _BreakfastPageState();
}

class _BreakfastPageState extends State<BreakfastPage> {
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

  // 텍스트 컨트롤러
  final TextEditingController textController = TextEditingController();

  // 텍스트 필드 포커스 노드
  final FocusNode focusNode = FocusNode();

  // 최대 글자 수
  final int maxCharacters = 100;

  // 텍스트 정렬 변경 기준 글자 수
  final int alignmentChangeThreshold = 30;

  // 아침 컨트롤러
  late BreakfastController breakfastController;

  // 구독 취소용 변수
  late Worker _subscription;

  // disposed 플래그
  bool disposed = false;

  @override
  void initState() {
    super.initState();

    // 컨트롤러 초기화
    breakfastController = Get.find<BreakfastController>();

    // 데이터 로드
    breakfastController.fetchBreakfasts();

    // breakfasts 리스트 변화 감지
    _subscription = ever(breakfastController.breakfasts,
        (List<BreakfastModel> breakfastList) {
      if (breakfastList.isNotEmpty && !disposed) {
        // 첫 번째 기록을 가져옴 (오늘 날짜의 기록일 것임)
        final todayBreakfast = breakfastList.first;

        // 텍스트 설정
        textController.text = todayBreakfast.breakfast_text;
        breakfastController.updateTextState(
            todayBreakfast.breakfast_text, alignmentChangeThreshold);

        print(
            '🔍 오늘의 아침 기록 발견: ID ${todayBreakfast.id}, 텍스트: ${todayBreakfast.breakfast_text}');
      }
    });

    // 텍스트 변경 리스너
    textController.addListener(() {
      final text = textController.text;
      breakfastController.updateTextState(text, alignmentChangeThreshold);
      breakfastController.enforceMaxLength(text, maxCharacters, textController);
    });

    // 포커스 리스너
    focusNode.addListener(() {
      if (focusNode.hasFocus && !breakfastController.hasText.value) {
        breakfastController.hasText.value = true;
      }
    });
  }

  @override
  void dispose() {
    disposed = true;
    _subscription.dispose();
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

  // 아침 기록 저장
  Future<void> _saveBreakfast() async {
    final breakfastText = textController.text;

    if (breakfastText.isEmpty) {
      _safeShowSnackbar(
        '입력 필요',
        '아침 식사 내용을 입력해주세요.',
        Colors.red[100]!,
      );
      return;
    }

    try {
      final success =
          await breakfastController.saveOrUpdateBreakfast(breakfastText);

      if (success) {
        final isUpdate = breakfastController.breakfasts.isNotEmpty;
        _safeShowSnackbar(
          isUpdate ? '수정 완료' : '저장 완료',
          isUpdate ? '아침 식사 기록이 수정되었습니다.' : '아침 식사가 기록되었습니다.',
          Colors.green[100]!,
        );

        // 화면을 닫고 결과 반환
        Get.back(result: breakfastText);
      } else {
        if (breakfastController.errorMessage.value.contains('로그인')) {
          _safeShowSnackbar(
            '로그인 필요',
            '아침 식사를 기록하려면 로그인이 필요합니다.',
            Colors.red[100]!,
          );
        } else {
          _safeShowSnackbar(
            '저장 실패',
            '아침 식사 기록 중 오류가 발생했습니다: ${breakfastController.errorMessage.value}',
            Colors.red[100]!,
          );
        }
      }
    } catch (e) {
      if (e.toString().contains('로그인')) {
        _safeShowSnackbar(
          '로그인 필요',
          '아침 식사를 기록하려면 로그인이 필요합니다.',
          Colors.red[100]!,
        );
      } else {
        _safeShowSnackbar(
          '오류',
          '아침 식사 기록 중 오류가 발생했습니다: $e',
          Colors.red[100]!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '아침 기록하기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          // 취소 버튼
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54),
            onPressed: () {
              textController.clear();

              // 오늘의 아침 기록이 있는 경우에만 삭제 시도
              if (breakfastController.breakfasts.isNotEmpty) {
                final todayBreakfast = breakfastController.breakfasts.first;
                if (todayBreakfast.id != null) {
                  breakfastController.deleteBreakfast(todayBreakfast.id!);
                }
              }

              Get.back(result: 'cancel');
              _safeShowSnackbar(
                '기록 취소',
                '아침 식사 기록이 취소되었습니다.',
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
                                      visible:
                                          !breakfastController.hasText.value,
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '아침은 뭘 드셨나요?',
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
                                        width:
                                            breakfastController.isLongText.value
                                                ? 309
                                                : 250,
                                        height:
                                            breakfastController.isLongText.value
                                                ? 202
                                                : 100,
                                        alignment:
                                            breakfastController.isLongText.value
                                                ? Alignment.topCenter
                                                : const Alignment(0, 0.8),
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
                                          textAlign: breakfastController
                                                  .isLongText.value
                                              ? TextAlign.start
                                              : TextAlign.center,
                                          textAlignVertical: breakfastController
                                                  .isLongText.value
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
                                // 컨트롤러를 통해 태그 삽입
                                breakfastController.insertTag(
                                    tag, textController, maxCharacters);

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
                              onPressed: breakfastController.isLoading.value
                                  ? null
                                  : _saveBreakfast,
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
                              child: breakfastController.isLoading.value
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
          Obx(() => breakfastController.isLoading.value
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
}
