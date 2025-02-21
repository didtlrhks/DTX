import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding.dart';
import 'controllers/survey_controller.dart';

void main() {
  Get.put(SurveyController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '앱 이름',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 페이지'),
      ),
      body: const Center(
        child: Text('홈 페이지입니다'),
      ),
    );
  }
}
