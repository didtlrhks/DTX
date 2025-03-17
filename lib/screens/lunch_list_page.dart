import 'package:dtxproject/models/lunch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/lunch_controller.dart';
import 'package:dtxproject/screens/input/launch_page.dart';

class LunchListPage extends StatefulWidget {
  const LunchListPage({super.key});

  @override
  State<LunchListPage> createState() => _LunchListPageState();
}

class _LunchListPageState extends State<LunchListPage> {
  final LunchController lunchController = Get.find<LunchController>();

  @override
  void initState() {
    super.initState();
    lunchController.fetchLunches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('점심 기록 목록'),
      ),
      body: Obx(() {
        if (lunchController.isLoading.value) {
          return const CircularProgressIndicator();
        } else if (lunchController.lunches.isEmpty) {
          return const Center(child: Text('점심 기록이 없습니다.'));
        } else {
          return ListView.builder(
            itemCount: lunchController.lunches.length,
            itemBuilder: (context, index) {
              final lunch = lunchController.lunches[index];
              return _buildLunchItem(lunch);
            },
          );
        }
      }),
    );
  }

  // 점심 기록 항목 위젯
  Widget _buildLunchItem(LunchModel lunch) {
    return GestureDetector(
      onTap: () {
        // 점심 기록 수정 화면으로 이동
        Get.to(() => LaunchPage(lunchToEdit: lunch))?.then((result) {
          if (result != null && result != 'cancel') {
            // 수정 후 목록 새로고침
            lunchController.fetchLunches();
          }
        });
      },
      child: Container(
          // ... existing lunch item UI ...
          ),
    );
  }
}
