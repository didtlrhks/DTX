import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseInputPage extends StatefulWidget {
  const ExerciseInputPage({super.key});

  @override
  State<ExerciseInputPage> createState() => _ExerciseInputPageState();
}

class _ExerciseInputPageState extends State<ExerciseInputPage> {
  // 선택된 운동 강도 (0: 선택 안됨, 1: 저강도, 2: 중강도, 3: 고강도)
  final RxInt selectedIntensity = 0.obs;

  // 텍스트 컨트롤러
  final TextEditingController textController = TextEditingController();

  // 텍스트 필드 포커스 노드
  final FocusNode focusNode = FocusNode();

  // 텍스트 입력 여부 상태
  final RxBool hasText = false.obs;

  String? get label => null;

  // 선택된 강도에 따른 색상 반환
  Color getSelectedColor() {
    switch (selectedIntensity.value) {
      case 1: // 저강도
        return const Color(0xFFA8EA92);
      case 2: // 중강도
        return const Color(0xFFFFAA55);
      case 3: // 고강도
        return const Color(0xFFFF5D29);
      default:
        return Colors.grey[100]!;
    }
  }

  @override
  void initState() {
    super.initState();

    // 텍스트 변경 리스너 추가
    textController.addListener(() {
      hasText.value = textController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // 컨트롤러와 포커스 노드 해제
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('운동 기록하기',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black54),
            onPressed: () {
              // 취소 결과 반환
              Get.back(result: 'cancel');
              Get.snackbar(
                '기록 취소',
                '운동 기록이 취소되었습니다.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 텍스트 필드 (349x242 크기)
                    Obx(() => Container(
                          width: 349,
                          height: 242,
                          decoration: BoxDecoration(
                            color: getSelectedColor(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              focusNode.requestFocus();
                            },
                            child: Stack(
                              children: [
                                // 플레이스홀더 (텍스트가 없을 때만 표시)
                                Visibility(
                                  visible: !hasText.value,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '오늘은 어떤 운동을 하셨나요?',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '예) 30분 걷기, 스트레칭 10분',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 텍스트 필드
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    controller: textController,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                    const SizedBox(height: 40),

                    // 타임라인과 원형 버튼 구현
                    SizedBox(
                      height: 120, // 원형 버튼과 텍스트를 포함할 충분한 높이
                      child: Stack(
                        children: [
                          // 가로 선 (타임라인) - 원의 중심을 지나도록 배치
                          Positioned(
                            top: 40, // 원의 중심 높이 (원 높이의 절반)
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              color: Colors.grey[300],
                            ),
                          ),

                          // 운동 강도 선택 버튼들
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 저강도 버튼
                              _buildIntensityButton(1, '저강도'),

                              // 중강도 버튼
                              _buildIntensityButton(2, '중강도'),

                              // 고강도 버튼
                              _buildIntensityButton(3, '고강도'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      onPressed: () => Get.back(),
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
                          onPressed: selectedIntensity.value > 0
                              ? () {
                                  // 저장 로직
                                  String intensityText = '';
                                  switch (selectedIntensity.value) {
                                    case 1:
                                      intensityText = '저강도';
                                      break;
                                    case 2:
                                      intensityText = '중강도';
                                      break;
                                    case 3:
                                      intensityText = '고강도';
                                      break;
                                  }

                                  // 텍스트 필드 내용과 함께 결과 반환
                                  final exerciseText =
                                      textController.text.isNotEmpty
                                          ? textController.text
                                          : intensityText;

                                  Get.back(result: exerciseText);
                                  Get.snackbar(
                                    '저장 완료',
                                    '$intensityText 운동이 기록되었습니다.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              : null, // 선택된 강도가 없으면 버튼 비활성화
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
                          child: const Text(
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
    );
  }

  // 운동 강도 선택 버튼 위젯
  Widget _buildIntensityButton(int intensity, String shortLabel) {
    // 강도에 따른 색상 설정
    Color getCircleColor(bool isSelected) {
      if (!isSelected) return Colors.white;

      switch (intensity) {
        case 1: // 저강도
          return const Color(0xFFA8EA92);
        case 2: // 중강도
          return const Color(0xFFFFAA55);
        case 3: // 고강도
          return const Color(0xFFFF5D29);
        default:
          return Colors.white;
      }
    }

    return Obx(() => Column(
          children: [
            GestureDetector(
              onTap: () {
                selectedIntensity.value = intensity;
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: getCircleColor(selectedIntensity.value == intensity),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIntensity.value == intensity
                        ? getCircleColor(true)
                        : Colors.grey[300]!,
                    width: selectedIntensity.value == intensity ? 2 : 1,
                  ),
                ),
                // 원 안에 글씨 넣기
                child: Center(
                  child: Text(
                    shortLabel,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: selectedIntensity.value == intensity
                          ? Colors.white
                          : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
