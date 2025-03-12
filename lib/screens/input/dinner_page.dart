import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DinnerPage extends StatelessWidget {
  // 식사 종류 목록
  final List<String> foodCategories = [
    '밥류',
    '빵류',
    '면류',
    '국/찌개',
    '반찬',
    '과일',
    '음료',
    '기타'
  ];

  // 식사량 옵션
  final List<String> portionSizes = ['소량', '보통', '많이'];

  // 선택된 식사 종류와 양을 관리하는 RxList
  static final RxList<Map<String, dynamic>> selectedFoods =
      <Map<String, dynamic>>[].obs;

  // 텍스트 컨트롤러
  static final TextEditingController foodNameController =
      TextEditingController();
  static final RxString selectedCategory = ''.obs;
  static final RxString selectedPortion = '보통'.obs;

  DinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아침 식사 기록'),
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
              // 저장 로직 구현
              Get.back();
              Get.snackbar('저장 완료', '아침 식사가 기록되었습니다.',
                  snackPosition: SnackPosition.BOTTOM);
            },
            child: const Text('저장', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 상단 정보 영역
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘 아침 식사를 기록해주세요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '식사 시간과 음식 종류, 양을 입력해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text('식사 시간:'),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        final TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        // 시간 선택 로직 구현
                      },
                      child: const Text('07:30 AM'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 식사 입력 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 음식 추가 폼
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '음식 추가',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: foodNameController,
                          decoration: const InputDecoration(
                            labelText: '음식 이름',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('음식 종류'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: foodCategories.map((category) {
                            return Obx(() => ChoiceChip(
                                  label: Text(category),
                                  selected: selectedCategory.value == category,
                                  onSelected: (selected) {
                                    if (selected) {
                                      selectedCategory.value = category;
                                    }
                                  },
                                ));
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text('식사량'),
                        const SizedBox(height: 8),
                        Obx(() => SegmentedButton<String>(
                              segments: portionSizes
                                  .map((size) => ButtonSegment<String>(
                                      value: size, label: Text(size)))
                                  .toList(),
                              selected: {selectedPortion.value},
                              onSelectionChanged: (Set<String> newSelection) {
                                selectedPortion.value = newSelection.first;
                              },
                            )),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (foodNameController.text.isNotEmpty &&
                                  selectedCategory.value.isNotEmpty) {
                                selectedFoods.add({
                                  'name': foodNameController.text,
                                  'category': selectedCategory.value,
                                  'portion': selectedPortion.value,
                                });
                                foodNameController.clear();
                                selectedCategory.value = '';
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('추가하기'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    '추가된 음식',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 추가된 음식 목록
                  Expanded(
                    child: Obx(() => selectedFoods.isEmpty
                        ? const Center(
                            child: Text('추가된 음식이 없습니다.'),
                          )
                        : ListView.builder(
                            itemCount: selectedFoods.length,
                            itemBuilder: (context, index) {
                              final food = selectedFoods[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  title: Text(food['name']),
                                  subtitle: Text(
                                      '${food['category']} · ${food['portion']}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      selectedFoods.removeAt(index);
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
