import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/models/dailyreview_model.dart';
import 'package:dtxproject/services/dailyreview_service.dart';
import 'package:dtxproject/controllers/auth_controller.dart';

class DailyReviewPage extends StatefulWidget {
  const DailyReviewPage({super.key});

  @override
  State<DailyReviewPage> createState() => _DailyReviewPageState();
}

class _DailyReviewPageState extends State<DailyReviewPage> {
  // AuthController 인스턴스 가져오기
  final AuthController _authController = Get.find<AuthController>();

  // API 호출 상태 관리
  final RxBool isLoading = false.obs;
  final RxBool isInitializing = true.obs; // 초기 데이터 로딩 상태

  // 각 탭별 선택된 항목 인덱스 관리
  final Map<String, int> _selectedIndices = {
    '배고픔': -1,
    '수면': -1,
    '활동량': -1,
    '감정': -1,
    '음주': -1,
  };

  // 최신 하루 리뷰
  Rx<DailyReview?> latestReview = Rx<DailyReview?>(null);

  // 현재 선택된 탭
  String _currentTab = '배고픔';

  // 탭 순서
  final List<String> _tabOrder = ['배고픔', '수면', '활동량', '감정', '음주'];

  // 탭별 질문과 설명
  final Map<String, Map<String, String>> _tabQuestions = {
    '배고픔': {
      'question': '오늘 하루 식사는 어떠셨나요?',
      'description': '혹시 배고프거나 과하게 드신 것 아니신가요?',
    },
    '수면': {
      'question': '오늘 잠은 어떠셨나요?',
      'description': '자주 깨거나 뒤척이진 않으셨나요?',
    },
    '활동량': {
      'question': '오늘은 얼마나 활동하셨나요?',
      'description': '몸을 좀 움직이셨나요?',
    },
    '감정': {
      'question': '오늘 수분 섭취는 어떠셨나요?',
      'description': '물을 충분히 마셨나요?',
    },
    '음주': {
      'question': '오늘 술은 어떠셨나요?',
      'description': '적당히 즐기셨나요?',
    },
  };

  // 탭별 리뷰 항목
  final Map<String, List<ReviewItem>> _tabReviewItems = {
    '배고픔': [
      ReviewItem(id: 1, title: '돌도 씹어먹을 것 같아요.🧸'),
      ReviewItem(id: 2, title: '참긴했지만 배가 자주 고팠어요.👩'),
      ReviewItem(id: 3, title: '약간 허전하지만 괜찮아요.😊'),
      ReviewItem(id: 4, title: '딱 적당했어요!👍'),
      ReviewItem(id: 5, title: '움직이기 힘들었을만큼 배불러요.🍽️'),
    ],
    '수면': [
      ReviewItem(id: 1, title: '밤새 뜬 눈으로 버텼어요.😴'),
      ReviewItem(id: 2, title: '뒤척이다 겨우 잠들었어요.😫'),
      ReviewItem(id: 3, title: '중간에 깨진 않았어요.🛌'),
      ReviewItem(id: 4, title: '개운하게 잤어요.😌'),
      ReviewItem(id: 5, title: '기절하듯 꿀잠 잤어요!.💤'),
    ],
    '활동량': [
      ReviewItem(id: 1, title: '하루종일 바닥에 붙어 있었어요.📱'),
      ReviewItem(id: 2, title: '가벼운 스트레칭 정도?.🚶'),
      ReviewItem(id: 3, title: '평소처럼 움직였어요.🏃'),
      ReviewItem(id: 4, title: '운동하고 개운해요!.🏋️'),
      ReviewItem(id: 5, title: '몸이 불타올라요🚴'),
    ],
    '감정': [
      ReviewItem(id: 1, title: '스트레스! 머리가 터질 것 같아요.'),
      ReviewItem(id: 2, title: '괜히 마음이 복잡해요💧'),
      ReviewItem(id: 3, title: '그냥 평범한 하루였어요.🚰'),
      ReviewItem(id: 4, title: '작은 행복이 있었어요.💦'),
      ReviewItem(id: 5, title: '기분이 날아 갈 것 같아요.🌊'),
    ],
    '음주': [
      ReviewItem(id: 1, title: '잔이 기억도 안나요.🙅'),
      ReviewItem(id: 2, title: '알딸딸~ 기분이 좋아요.🍺'),
      ReviewItem(id: 3, title: '딱 적당히 즐겼어요.🍷'),
      ReviewItem(id: 4, title: '살짝 맛만 봤어요.🍸'),
      ReviewItem(id: 5, title: '오늘은 술 패스!.🥴'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchLatestReview();
  }

  // 최신 하루 리뷰 조회 및 선택 항목 설정
  Future<void> _fetchLatestReview() async {
    if (_authController.user.value == null) {
      isInitializing.value = false;
      return;
    }

    try {
      isInitializing.value = true;
      final userId = _authController.user.value!.id!;

      // 최신 하루 리뷰 조회
      final review = await DailyReviewService.getLatestDailyReview(userId);

      if (review != null) {
        latestReview.value = review;

        // 조회된 리뷰에 맞게 선택 항목 설정
        _setSelectedIndicesFromReview(review);
      }
    } catch (e) {
      print('하루 리뷰 조회 오류: $e');
    } finally {
      isInitializing.value = false;
    }
  }

  // 조회된 리뷰에 맞게 선택 항목 설정
  void _setSelectedIndicesFromReview(DailyReview review) {
    // 각 탭별로 선택 항목 찾기
    _setTabSelectionByOption('배고픔', review.hungerOption);
    _setTabSelectionByOption('수면', review.sleepOption);
    _setTabSelectionByOption('활동량', review.activityOption);
    _setTabSelectionByOption('감정', review.emotionOption);
    _setTabSelectionByOption('음주', review.alcoholOption);
  }

  // 특정 탭의 선택 항목 설정 (옵션 번호로)
  void _setTabSelectionByOption(String tab, int optionNumber) {
    // 옵션 번호는 1부터 시작하므로 인덱스는 optionNumber - 1
    int index = optionNumber - 1;

    // 유효한 범위인지 확인
    if (index >= 0 && index < (_tabReviewItems[tab]?.length ?? 0)) {
      setState(() {
        _selectedIndices[tab] = index;
      });
    }
  }

  // 마지막 탭인지 확인
  bool get _isLastTab {
    return _currentTab == _tabOrder.last;
  }

  // 현재 선택된 인덱스
  int get _currentSelectedIndex => _selectedIndices[_currentTab] ?? -1;

  // 첫 번째 탭인지 확인
  bool get _isFirstTab {
    return _currentTab == _tabOrder.first;
  }

  // 모든 이전 탭이 완료되었는지 확인하는 메서드 추가
  bool get _allPreviousTabsCompleted {
    // 마지막 탭이 아닌 경우 항상 false 반환
    if (!_isLastTab) return false;

    // 마지막 탭을 제외한 모든 탭을 확인
    for (int i = 0; i < _tabOrder.length - 1; i++) {
      String tab = _tabOrder[i];
      if (_selectedIndices[tab]! < 0) {
        return false; // 완료되지 않은 탭이 있으면 false
      }
    }
    return true; // 모든 이전 탭이 완료됨
  }

  // 모든 탭이 완료되었는지 확인
  bool get _allTabsCompleted {
    for (String tab in _tabOrder) {
      if (_selectedIndices[tab]! < 0) {
        return false; // 완료되지 않은 탭이 있으면 false
      }
    }
    return true; // 모든 탭이 완료됨
  }

  @override
  Widget build(BuildContext context) {
    // 현재 탭에 맞는 리뷰 항목들
    final currentReviewItems = _tabReviewItems[_currentTab] ?? [];

    // 현재 탭에 맞는 질문과 설명
    final currentQuestion = _tabQuestions[_currentTab]?['question'] ?? '';
    final currentDescription = _tabQuestions[_currentTab]?['description'] ?? '';

    // 다음 버튼 텍스트 결정 - 수정된 로직
    final nextButtonText = latestReview.value != null
        ? '확인했습니다'
        : (_isLastTab &&
                _currentSelectedIndex >= 0 &&
                _allPreviousTabsCompleted)
            ? '완료'
            : '다음';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => _onWillPop(),
          ),
        ),
        body: Obx(() {
          if (isInitializing.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // 탭 메뉴 - 스크롤 제거 및 화면에 꽉 차게 변경
              Container(
                width: MediaQuery.of(context).size.width, // 전체 화면 너비 사용
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0), // 가로 패딩 제거, 세로 패딩만 유지
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 균등 배치
                  children: _tabOrder.map((tab) {
                    bool isSelected = _currentTab == tab;
                    return _buildTabItem(
                      tab,
                      isSelected: isSelected,
                    );
                  }).toList(),
                ),
              ),

              // 질문 영역
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQuestion,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 리뷰 항목들
                    ...currentReviewItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _buildReviewItem(item, index);
                    }),
                  ],
                ),
              ),

              const Spacer(),

              // 최신 리뷰 정보 표시 (있는 경우)
              // if (latestReview.value != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20),
              //     child: Container(
              //       width: double.infinity,
              //       padding: const EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         color: Colors.grey[100],
              //         borderRadius: BorderRadius.circular(8),
              //         border: Border.all(color: Colors.grey[300]!),
              //       ),
              //       child: Text(
              //         '이전 리뷰: ${_formatDate(latestReview.value!.reviewDate)}',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           color: Colors.grey[700],
              //           fontSize: 14,
              //         ),
              //       ),
              //     ),
              //   ),

              // 하단 네비게이션 버튼
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              _isFirstTab ? Colors.grey[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: _isFirstTab
                              ? null // 첫 번째 탭에서는 이전 버튼 비활성화
                              : () {
                                  _moveToPreviousTab();
                                },
                          child: Text(
                            '이전',
                            style: TextStyle(
                              color: _isFirstTab
                                  ? Colors.grey[400]
                                  : Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: _currentSelectedIndex >= 0
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: (_currentSelectedIndex >= 0 &&
                                      !isLoading.value)
                                  ? () {
                                      if (_isLastTab &&
                                          _allPreviousTabsCompleted) {
                                        // 모든 이전 탭이 완료된 경우에만 완료 처리
                                        _submitDailyReview();
                                      } else {
                                        // 다음 탭으로 이동
                                        _moveToNextTab();
                                      }
                                    }
                                  : null,
                              child: isLoading.value
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 3,
                                    )
                                  : Text(
                                      nextButtonText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 날짜 포맷 변환 (YYYY-MM-DDT00:00:00.000Z -> YYYY년 MM월 DD일)
  String _formatDate(String dateStr) {
    try {
      final DateTime dateTime = DateTime.parse(dateStr);
      return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
    } catch (e) {
      print('날짜 변환 오류: $e');
      return dateStr;
    }
  }

  // 하루 리뷰 API 제출
  Future<void> _submitDailyReview() async {
    // 사용자 로그인 확인
    if (_authController.user.value == null) {
      Get.snackbar(
        '오류',
        '로그인이 필요합니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // 이미 완료된 리뷰가 있는 경우 토스트 메시지 표시
    if (latestReview.value != null) {
      Get.snackbar(
        '알림',
        '하루 리뷰는 변경할 수 없습니다. 자정 12시에 초기화됩니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue[100],
        colorText: Colors.blue[800],
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // 모든 탭이 완료되었는지 확인
    if (!_allTabsCompleted) {
      Get.snackbar(
        '알림',
        '모든 항목을 선택해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
      return;
    }

    try {
      isLoading.value = true; // 로딩 시작

      // 사용자 ID 가져오기
      final userId = _authController.user.value!.id!;

      // 선택된 데이터 가져오기
      final hungerIndex = _selectedIndices['배고픔']!;
      final sleepIndex = _selectedIndices['수면']!;
      final activityIndex = _selectedIndices['활동량']!;
      final emotionIndex = _selectedIndices['감정']!;
      final alcoholIndex = _selectedIndices['음주']!;

      // 선택된 텍스트 가져오기
      final hungerText = _tabReviewItems['배고픔']![hungerIndex].title;
      final sleepText = _tabReviewItems['수면']![sleepIndex].title;
      final activityText = _tabReviewItems['활동량']![activityIndex].title;
      final emotionText = _tabReviewItems['감정']![emotionIndex].title;
      final alcoholText = _tabReviewItems['음주']![alcoholIndex].title;

      // 선택한 옵션 번호 (1부터 시작)
      final hungerOption = hungerIndex + 1;
      final sleepOption = sleepIndex + 1;
      final activityOption = activityIndex + 1;
      final emotionOption = emotionIndex + 1;
      final alcoholOption = alcoholIndex + 1;

      // DailyReview 모델 생성
      final dailyReview = DailyReview(
        userId: userId,
        reviewDate: DailyReviewService.getTodayFormatted(),
        hungerOption: hungerOption,
        hungerText: hungerText,
        sleepOption: sleepOption,
        sleepText: sleepText,
        activityOption: activityOption,
        activityText: activityText,
        emotionOption: emotionOption,
        emotionText: emotionText,
        alcoholOption: alcoholOption,
        alcoholText: alcoholText,
      );

      // API 호출
      final success = await DailyReviewService.saveDailyReview(dailyReview);

      if (success) {
        // 성공 시 결과 반환 및 이전 화면으로 이동
        Get.back(result: dailyReview);

        // 메시지는 홈 화면에서 표시
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.snackbar(
            '성공',
            '하루 리뷰가 성공적으로 저장되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
          );
        });
      } else {
        // 실패 시 에러 메시지
        Get.snackbar(
          '오류',
          '하루 리뷰 저장에 실패했습니다. 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      // 예외 발생 시 에러 메시지
      Get.snackbar(
        '오류',
        '하루 리뷰 저장 중 오류가 발생했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }

  // 뒤로가기 처리
  Future<bool> _onWillPop() async {
    // 이미 완료된 리뷰가 있는 경우 결과 없이 바로 뒤로가기
    if (latestReview.value != null) {
      Get.back(); // 결과를 전달하지 않음 - 이렇게 하면 홈 화면에서 상태가 변경되지 않음
      return true;
    }

    // 모든 탭에서 선택된 항목이 있는지 확인
    bool hasSelections = _selectedIndices.values.any((index) => index >= 0);

    if (hasSelections) {
      // 다이얼로그 표시
      bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('설문 종료'),
          content: const Text('여기서 나가면 다시 설문해야 합니다. 계속하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('확인'),
            ),
          ],
        ),
      );

      // 사용자가 확인을 누른 경우 (true) 뒤로 가기
      if (result == true) {
        Get.back(result: 'cancel'); // 취소 결과 전달
        return true;
      }

      // 취소한 경우
      return false;
    }

    // 선택된 항목이 없는 경우 바로 뒤로 가기
    Get.back(result: 'cancel'); // 취소 결과 전달
    return true;
  }

  // 다음 탭으로 이동
  void _moveToNextTab() {
    final currentIndex = _tabOrder.indexOf(_currentTab);
    if (currentIndex < _tabOrder.length - 1) {
      setState(() {
        _currentTab = _tabOrder[currentIndex + 1];
      });
    }
  }

  // 이전 탭으로 이동
  void _moveToPreviousTab() {
    final currentIndex = _tabOrder.indexOf(_currentTab);
    if (currentIndex > 0) {
      setState(() {
        _currentTab = _tabOrder[currentIndex - 1];
      });
    }
  }

  // 탭 선택 시 호출
  void _selectTab(String tabName) {
    setState(() {
      _currentTab = tabName;
    });
  }

  // 항목 선택 시 호출
  void _selectItem(int index) {
    setState(() {
      _selectedIndices[_currentTab] = index;
    });
  }

  // 탭 아이템 위젯 - 위치 안정화를 위한 구조 개선
  Widget _buildTabItem(String title, {bool isSelected = false}) {
    // 고정된 크기의 컨테이너를 사용하여 위치 안정화
    return GestureDetector(
      onTap: () => _selectTab(title),
      child: Container(
        width: 65, // 고정 너비 설정
        height: 32, // 고정 높이 설정
        alignment: Alignment.center, // 중앙 정렬
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 선택 시 보여줄 배경
            if (isSelected)
              Container(
                width: 60,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(26.5),
                ),
              ),
            // 텍스트는 항상 중앙에 고정
            Text(
              title,
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 리뷰 항목 위젯
  Widget _buildReviewItem(ReviewItem item, int index) {
    final isSelected = _selectedIndices[_currentTab] == index;

    return GestureDetector(
      onTap: () {
        _selectItem(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(26.5), // 요청하신 radius 값
          // 스트로크 없음 (border 제거)
        ),
        child: Row(
          children: [
            Text(
              '${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
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
