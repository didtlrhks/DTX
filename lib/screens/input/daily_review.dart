import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyReviewPage extends StatefulWidget {
  const DailyReviewPage({super.key});

  @override
  State<DailyReviewPage> createState() => _DailyReviewPageState();
}

class _DailyReviewPageState extends State<DailyReviewPage> {
  // 선택된 아이템의 인덱스 (0부터 시작, -1은 선택 안됨)
  int _selectedIndex = -1;

  // 리뷰 항목 리스트
  final List<ReviewItem> _reviewItems = [
    ReviewItem(
      id: 1,
      title: '몸도 마음이랑 같이 무거워요.🧸',
    ),
    ReviewItem(
      id: 2,
      title: '참진짜지만 배가 자주 고팠어요.👩',
    ),
    ReviewItem(
      id: 3,
      title: '약간 허전하지만 괜찮아요.😊',
    ),
    ReviewItem(
      id: 4,
      title: '딱 적당했어요!👍',
    ),
    ReviewItem(
      id: 5,
      title: '오늘하기 힘들었을 배불러요.🍽️',
    ),
  ];

  // 현재 선택된 탭
  String _currentTab = '배고품';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '하루 리뷰',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(result: 'cancel'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // 탭 메뉴
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabItem('배고품', isSelected: _currentTab == '배고품'),
                    _buildTabItem('수면', isSelected: _currentTab == '수면'),
                    _buildTabItem('활동량', isSelected: _currentTab == '활동량'),
                    _buildTabItem('갈증', isSelected: _currentTab == '갈증'),
                    _buildTabItem('음주', isSelected: _currentTab == '음주'),
                  ],
                ),
              ),
            ),
          ),

          // 질문 영역
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘 하루 식사는 어떠셨나요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '혹시 배고프거나 과하게 드신 것 아니신가요?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                // 리뷰 항목들
                ..._reviewItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildReviewItem(item, index);
                }),
              ],
            ),
          ),

          const Spacer(),

          // 하단 네비게이션 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Get.back(result: 'cancel');
                      },
                      child: const Text(
                        '이전',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: _selectedIndex >= 0
                          ? Colors.grey[600]
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: _selectedIndex >= 0
                          ? () {
                              // 선택된 항목이 있을 때만 다음으로 진행
                              final selectedItem = _reviewItems[_selectedIndex];
                              // Home 페이지에 결과 반환
                              Get.back(result: selectedItem.id.toString());
                            }
                          : null,
                      child: const Text(
                        '다음',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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

  // 탭 아이템 위젯
  Widget _buildTabItem(String title, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // 리뷰 항목 위젯
  Widget _buildReviewItem(ReviewItem item, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              '${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: isSelected ? 16 : 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: isSelected ? 16 : 14,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.black,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// 리뷰 항목 모델
class ReviewItem {
  final int id;
  final String title;

  ReviewItem({
    required this.id,
    required this.title,
  });
}
