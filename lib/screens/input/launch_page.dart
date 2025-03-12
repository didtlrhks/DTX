import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaunchPage extends StatelessWidget {
  LaunchPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('점심 기록하기',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black54),
            onPressed: () {
              // 텍스트 필드 내용 삭제
              textController.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 입력 영역
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '점심은 뭘 드셨나요?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '예) 라면 반그릇, 단무지 3개, 도시락 248칼로리',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 텍스트 필드 추가
                        TextField(
                          controller: textController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '여기에 입력하세요',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 5,
                          minLines: 3,
                        ),
                      ],
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

                            // 현재 커서 위치 또는 텍스트 끝에 태그 삽입
                            final newText = selection.isValid
                                ? currentText.substring(0, selection.start) +
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
                    child: ElevatedButton(
                      onPressed: () {
                        // 저장 로직
                        final mealText = textController.text;
                        if (mealText.isNotEmpty) {
                          Get.back(result: mealText);
                          Get.snackbar(
                            '저장 완료',
                            '점심 식사가 기록되었습니다.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.snackbar(
                            '입력 필요',
                            '점심 식사 내용을 입력해주세요.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[100],
                            colorText: Colors.red[900],
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '저장',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
