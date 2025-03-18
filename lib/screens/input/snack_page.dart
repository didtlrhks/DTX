import 'package:dtxproject/models/snack_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/snack_controller.dart';
import 'package:dtxproject/services/snack_service.dart';

class SnackPage extends StatefulWidget {
  final String? savedSnackText;

  const SnackPage({
    super.key,
    this.savedSnackText,
  });

  @override
  State<SnackPage> createState() => _SnackPageState();
}

class _SnackPageState extends State<SnackPage> {
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

  // 간식 컨트롤러
  late SnackController snackController;

  // 구독 취소용 변수
  late Worker _subscription;

  // disposed 플래그
  bool disposed = false;

  @override
  void initState() {
    super.initState();

    // SnackService 찾기 또는 생성하기
    SnackService snackService;
    try {
      snackService = Get.find<SnackService>();
    } catch (e) {
      // SnackService가 등록되어 있지 않으면 새로 생성하고 등록
      snackService = SnackService();
      Get.put(snackService);
      print('SnackService 생성 및 등록됨');
    }

    // SnackController 찾기 또는 생성하기
    try {
      snackController = Get.find<SnackController>();
    } catch (e) {
      // SnackController가 등록되어 있지 않으면 새로 생성하고 등록
      snackController = SnackController(snackService: snackService);
      Get.put(snackController);
      print('SnackController 생성 및 등록됨');
    }

    // 사용자 ID 설정 (테스트용, 실제로는 로그인 후 설정해야 함)
    snackService.setUserId(1);

    // 데이터 로드
    snackController.fetchSnacks();

    // snacks 리스트 변화 감지
    _subscription = ever(snackController.snacks, (List<SnackModel> snackList) {
      if (snackList.isNotEmpty && !disposed) {
        // 첫 번째 기록을 가져옴 (오늘 날짜의 기록일 것임)
        final todaySnack = snackList.first;

        // 텍스트 설정
        textController.text = todaySnack.snack_text;
        snackController.updateTextState(
            todaySnack.snack_text, alignmentChangeThreshold);

        print(
            '🔍 오늘의 간식 기록 발견: ID ${todaySnack.id}, 텍스트: ${todaySnack.snack_text}');
      }
    });

    // 텍스트 변경 리스너
    textController.addListener(() {
      final text = textController.text;
      snackController.updateTextState(text, alignmentChangeThreshold);
      snackController.enforceMaxLength(text, maxCharacters, textController);
    });

    // 포커스 리스너
    focusNode.addListener(() {
      if (focusNode.hasFocus && !snackController.hasText.value) {
        snackController.hasText.value = true;
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

  // 간식 기록 저장
  Future<void> _saveSnack() async {
    final snackText = textController.text;

    if (snackText.isEmpty) {
      _safeShowSnackbar(
        '입력 필요',
        '간식 내용을 입력해주세요.',
        Colors.red[100]!,
      );
      return;
    }

    try {
      final success = await snackController.saveOrUpdateSnack(snackText);

      if (success) {
        final isUpdate = snackController.snacks.isNotEmpty;
        _safeShowSnackbar(
          isUpdate ? '수정 완료' : '저장 완료',
          isUpdate ? '간식 기록이 완료되었습니다.' : '간식이 기록되었습니다.',
          Colors.green[100]!,
        );

        // 화면을 닫고 결과 반환
        Get.back(result: snackText);
      } else {
        if (snackController.errorMessage.value.contains('로그인')) {
          _safeShowSnackbar(
            '로그인 필요',
            '간식을 기록하려면 로그인이 필요합니다.',
            Colors.red[100]!,
          );
        } else {
          _safeShowSnackbar(
            '저장 실패',
            '간식 기록 중 오류가 발생했습니다: ${snackController.errorMessage.value}',
            Colors.red[100]!,
          );
        }
      }
    } catch (e) {
      if (e.toString().contains('로그인')) {
        _safeShowSnackbar(
          '로그인 필요',
          '간식을 기록하려면 로그인이 필요합니다.',
          Colors.red[100]!,
        );
      } else {
        _safeShowSnackbar(
          '오류',
          '간식 기록 중 오류가 발생했습니다: $e',
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
          '간식 기록하기',
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

              // 오늘의 간식 기록이 있는 경우에만 삭제 시도
              if (snackController.snacks.isNotEmpty) {
                final todaySnack = snackController.snacks.first;
                if (todaySnack.id != null) {
                  snackController.deleteSnack(todaySnack.id!);
                }
              }

              Get.back(result: 'cancel');
              _safeShowSnackbar(
                '기록 취소',
                '간식 기록이 취소되었습니다.',
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
                                      visible: !snackController.hasText.value,
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '간식은 뭘 드셨나요?',
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
                                        width: snackController.isLongText.value
                                            ? 309
                                            : 250,
                                        height: snackController.isLongText.value
                                            ? 202
                                            : 100,
                                        alignment:
                                            snackController.isLongText.value
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
                                          textAlign:
                                              snackController.isLongText.value
                                                  ? TextAlign.start
                                                  : TextAlign.center,
                                          textAlignVertical:
                                              snackController.isLongText.value
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
                                snackController.insertTag(
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
                              onPressed: snackController.isLoading.value
                                  ? null
                                  : _saveSnack,
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
                              child: snackController.isLoading.value
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
          Obx(() => snackController.isLoading.value
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
