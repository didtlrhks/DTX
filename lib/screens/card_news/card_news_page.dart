import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardNewsPage extends StatefulWidget {
  const CardNewsPage({super.key});

  @override
  State<CardNewsPage> createState() => _CardNewsPageState();
}

class _CardNewsPageState extends State<CardNewsPage> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  // 샘플 카드 뉴스 데이터 - running.png 이미지 사용
  final List<Map<String, dynamic>> _cardNews = [
    {
      'title': '하루 30분 걷기 하기!',
      'imageUrl': 'assets/images/running.png',
    },
    {
      'title': '식단 관리 시작하기',
      'imageUrl': 'assets/images/running.png',
    },
    {
      'title': '충분한 수면 취하기',
      'imageUrl': 'assets/images/running.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    // 페이지 변경 감지
    _pageController.addListener(() {
      if (_pageController.page != null) {
        _currentPage.value = _pageController.page!.round();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비 기준으로 이미지 크기 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth > 390 ? 390.0 : screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '카드 뉴스',
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
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 고정된 제목 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Obx(() => Text(
                    _cardNews[_currentPage.value]['title'] ?? '제목 없음',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          ),

          // 이미지만 롤링되는 영역
          SizedBox(
            height: imageSize,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _cardNews.length,
              itemBuilder: (context, index) {
                return _buildCardNewsImage(_cardNews[index], imageSize);
              },
            ),
          ),

          // 고정된 하단 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dr. Expert',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 페이지 인디케이터
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _cardNews.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage.value == index
                            ? Colors.black
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // 이미지만 표시하는 위젯
  Widget _buildCardNewsImage(Map<String, dynamic> cardData, double size) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: cardData['imageUrl'] != null
            ? Image.asset(
                cardData['imageUrl'],
                fit: BoxFit.contain, // 이미지가 전체적으로 보이도록 contain 사용
                width: size,
                height: size,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패 시 대체 UI
                  return Container(
                    color: Colors.blue[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_run,
                          size: 80,
                          color: Colors.blue[800],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '운동하는 사람들',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                // 이미지가 없을 경우 대체 UI
                color: Colors.blue[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_run,
                      size: 80,
                      color: Colors.blue[800],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '운동하는 사람들',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
