import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
//import 'package:dtxproject/constants/app_theme.dart';
import 'package:dtxproject/screens/survey_screens/alcohol_survey/alcohol_survey_page_2.dart';

class AlcoholSurveyPage1 extends StatelessWidget {
  final surveyController = Get.find<SurveyController>();

  AlcoholSurveyPage1({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 전체 너비
    double screenWidth = MediaQuery.of(context).size.width;
    // 좌우 패딩과 가운데 간격을 제외한 너비
    double availableWidth = screenWidth - 50 - 4; // 50: 좌우 패딩 합, 4: 가운데 간격
    // 진행 바 개당 너비
    double progressBarWidth = availableWidth / 2; // 문항 수 만큼 나누기
    return Scaffold(
      backgroundColor: Color(0xFF9D9D9D), // 배경색 적용
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 바 (뒤로가기 버튼 + 제목)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool shouldPop = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15.0), // 모서리 둥글게 설정
                          ),
                          backgroundColor: Colors.white, // 배경색 흰색으로 설정
                          contentPadding: EdgeInsets.only(top: 30),
                          content: const Text('재시작 시,\n이전 문항의 기록이\n모두 사라집니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16)),
                          actionsPadding:
                              const EdgeInsets.all(20), // 버튼 위쪽에 여백 추가

                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(double.infinity, 50), //버튼 크기
                                      backgroundColor: Color(0xff00102B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12.0), // 버튼 모서리 둥글게
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0), // 버튼 사이의 간격
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(double.infinity, 50), //버튼 크기

                                      backgroundColor: Color(0xffD9D9D9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12.0), // 버튼 모서리 둥글게
                                      ),
                                    ),
                                    onPressed: () {
                                      surveyController
                                          .clearAlcoholSurveys(); // 모든 응답 초기화
                                      surveyController
                                          .resetAlcoholSurveys(); // 홈 화면에서 비활성화
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff656565)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                      if (shouldPop) {
                        Get.back();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      children: [
                        TextSpan(
                            text: '음주',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Paperlogy')),
                        TextSpan(
                            text: ' 설문조사',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'Paperlogy')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 진행 상태 표시
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xff4D4D4D), // 첫 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 두 번째 진행 바 색상
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      // 질문 설명
                      const Text(
                        '다음은 최근 1년 동안의\n음주(술) 경험에 대한 질문입니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 130),
                      const Text(
                        '1. 술을 얼마나 자주 마십니까?',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),

                      // 객관식 문항이 있는 사각형 박스
                      Container(
                        width: MediaQuery.of(context).size.width - 34,
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(3, (index) {
                                //객관식 문항
                                List<String> options = [
                                  '최근 1년간 전혀 마시지 않았다',
                                  '한달에 1~2번 정도',
                                  '주 1회 이상'
                                ];
                                return Obx(
                                  () {
                                    // 옵션 선택 확인
                                    bool isSelected = surveyController
                                            .alcoholQ1Option.value ==
                                        index;
                                    return GestureDetector(
                                      onTap: () => surveyController
                                          .alcoholQ1Option.value = index,
                                      child: IntrinsicWidth(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 20.0),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Color(0xff4E4E4E)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Text(
                                            options[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                            // 주관식 입력란 (한 주에 00잔)
                            Obx(() {
                              // '주 1회 이상' 옵션이 선택된 경우에만 표시
                              if (surveyController.alcoholQ1Option.value == 2) {
                                return Positioned(
                                  bottom: 8.0, // 세 번째 옵션의 위치에 맞춤 (밑에서부터 패딩 8만큼)
                                  right: 8.0, //우측정렬
                                  child: Row(
                                    children: [
                                      const Text(
                                        '한 주에 ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 12),
                                      Container(
                                        width: 78,
                                        height: 37,
                                        child: TextField(
                                          onChanged: (value) {
                                            surveyController.alcoholQ1InputText
                                                .value = value;
                                          },
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 5.0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        ' 잔',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox.shrink(); // 표시하지 않음
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 다음 버튼
      bottomNavigationBar: Obx(() {
        bool isButtonEnabled = surveyController.alcoholQ1Option.value != -1 &&
            (surveyController.alcoholQ1Option.value != 2 ||
                surveyController.alcoholQ1InputText.value.isNotEmpty);
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 42.0),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isButtonEnabled ? Color(0xff363636) : Color(0xffD9D9D9),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xffD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // 버튼 모서리 둥글게
                ),
              ),
              onPressed: isButtonEnabled
                  ? () {
                      Get.to(() => AlcoholSurveyPage2()); // 다음 페이지 이동
                    }
                  : null,
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
        );
      }),
    );
  }
}
