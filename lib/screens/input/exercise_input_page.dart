import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseCard {
  final String text;
  final int intensity;
  final DateTime createdAt;
  bool isSelected;

  ExerciseCard({
    required this.text,
    required this.intensity,
    required this.createdAt,
    this.isSelected = false,
  });

  // 강도에 따른 색상 반환
  Color getColor() {
    switch (intensity) {
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

  // 강도에 따른 텍스트 반환
  String getIntensityText() {
    switch (intensity) {
      case 1:
        return '저강도';
      case 2:
        return '중강도';
      case 3:
        return '고강도';
      default:
        return '';
    }
  }
}

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

  // 운동 카드 목록
  final RxList<ExerciseCard> exerciseCards = <ExerciseCard>[].obs;

  // 삭제 모드 상태
  final RxBool isDeleteMode = false.obs;

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

  // 운동 카드 추가
  void addExerciseCard() {
    if (selectedIntensity.value > 0 && textController.text.isNotEmpty) {
      final newCard = ExerciseCard(
        text: textController.text,
        intensity: selectedIntensity.value,
        createdAt: DateTime.now(),
      );

      exerciseCards.add(newCard);

      // 입력 필드 초기화
      textController.clear();
      selectedIntensity.value = 0;
    }
  }

  // 선택된 카드 삭제
  void deleteSelectedCards() {
    exerciseCards.removeWhere((card) => card.isSelected);
    isDeleteMode.value = false;
  }

  // 삭제 모드 취소
  void cancelDeleteMode() {
    isDeleteMode.value = false;
    for (var card in exerciseCards) {
      card.isSelected = false;
    }
    exerciseCards.refresh();
  }

  // 강도에 따른 텍스트 반환
  String _getIntensityText(int intensity) {
    switch (intensity) {
      case 1:
        return '저강도';
      case 2:
        return '중강도';
      case 3:
        return '고강도';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 처리
        if (exerciseCards.isNotEmpty) {
          Get.back(result: 'completed');
        } else {
          Get.back(result: 'cancel');
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('운동 기록하기',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (exerciseCards.isNotEmpty) {
                Get.back(result: 'completed');
              } else {
                Get.back(result: 'cancel');
              }
            },
          ),
          actions: [
            Obx(() => IconButton(
                  icon: Icon(
                    isDeleteMode.value ? Icons.close : Icons.delete_outline,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    if (exerciseCards.isEmpty) return;

                    if (isDeleteMode.value) {
                      cancelDeleteMode();
                    } else {
                      isDeleteMode.value = true;
                    }
                  },
                )),
          ],
        ),
        body: Column(
          children: [
            // 입력 영역 (항상 표시)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 텍스트 필드 (349x242 크기)
                  Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                              enabled: !isDeleteMode.value, // 삭제 모드에서는 비활성화
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

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
                            _buildIntensityButton(1, "저"),

                            // 중강도 버튼
                            _buildIntensityButton(2, "중"),

                            // 고강도 버튼
                            _buildIntensityButton(3, "고"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 운동 카드 목록
            Expanded(
              child: Obx(() => exerciseCards.isEmpty
                  ? const Center(
                      child: Text(
                        '운동 기록이 없습니다.\n운동 강도와 내용을 입력 후 저장해주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: exerciseCards.length,
                      itemBuilder: (context, index) {
                        final card = exerciseCards[index];
                        return GestureDetector(
                          onTap: () {
                            if (isDeleteMode.value) {
                              card.isSelected = !card.isSelected;
                              exerciseCards.refresh();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: card.getColor().withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: isDeleteMode.value && card.isSelected
                                  ? Border.all(
                                      color: Colors.red,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // 선택 체크박스 (삭제 모드일 때만 표시)
                                  if (isDeleteMode.value)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Icon(
                                        card.isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: card.isSelected
                                            ? Colors.red
                                            : Colors.black54,
                                      ),
                                    ),

                                  // 카드 내용
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                card.getIntensityText(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${card.createdAt.hour.toString().padLeft(2, '0')}:${card.createdAt.minute.toString().padLeft(2, '0')}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          card.text,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
            ),

            // 하단 버튼 영역
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => isDeleteMode.value
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            margin: const EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              onPressed: () => cancelDeleteMode(),
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
                            child: ElevatedButton(
                              onPressed: () => deleteSelectedCards(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '삭제',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            (selectedIntensity.value > 0 && hasText.value)
                                ? () => addExerciseCard()
                                : null,
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
                      ),
                    )),
            ),
          ],
        ),
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
                if (!isDeleteMode.value) {
                  selectedIntensity.value = intensity;
                }
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
