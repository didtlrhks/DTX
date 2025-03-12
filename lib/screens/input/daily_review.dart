import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyReviewPage extends StatelessWidget {
  DailyReviewPage({super.key});

  // 별점 관리
  final RxInt rating = 3.obs;

  // 기분 상태 관리
  final RxString selectedMood = '보통이에요'.obs;

  // 메모 컨트롤러
  final TextEditingController memoController = TextEditingController();

  // 기분 목록
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'text': '행복해요', 'color': Colors.yellow[700]},
    {'emoji': '😌', 'text': '만족해요', 'color': Colors.green[300]},
    {'emoji': '😐', 'text': '보통이에요', 'color': Colors.blue[300]},
    {'emoji': '😔', 'text': '아쉬워요', 'color': Colors.orange[300]},
    {'emoji': '😞', 'text': '힘들어요', 'color': Colors.red[300]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('오늘 하루 별점 리뷰'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 저장 로직
              Get.back();
              Get.snackbar(
                '저장 완료',
                '오늘의 리뷰가 저장되었습니다.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('저장', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 안내 텍스트
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘 하루는 어땠나요?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '오늘 하루를 돌아보고 별점과 기분을 기록해보세요.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 별점 섹션
              const Text(
                '오늘 하루 별점',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < rating.value
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 40,
                                color: index < rating.value
                                    ? Colors.amber
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                rating.value = index + 1;
                              },
                            );
                          }),
                        )),
                    const SizedBox(height: 10),
                    Obx(() => Text(
                          '${rating.value}점',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 기분 선택 섹션
              const Text(
                '오늘의 기분',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: moods.map((mood) {
                        return Obx(() => GestureDetector(
                              onTap: () {
                                selectedMood.value = mood['text'];
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedMood.value == mood['text']
                                      ? mood['color']!.withOpacity(0.2)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selectedMood.value == mood['text']
                                        ? mood['color']!
                                        : Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      mood['emoji'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      mood['text'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            selectedMood.value == mood['text']
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 메모 섹션
              const Text(
                '오늘의 메모',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: memoController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: '오늘 하루를 간단히 기록해보세요...',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 저장 로직
                    Get.back();
                    Get.snackbar(
                      '저장 완료',
                      '오늘의 리뷰가 저장되었습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
