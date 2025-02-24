import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('프로필 설정'),
            onTap: () {
              // 프로필 설정 페이지로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('알림 설정'),
            onTap: () {
              // 알림 설정 페이지로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('개인정보 처리방침'),
            onTap: () {
              // 개인정보 처리방침 페이지로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('앱 정보'),
            onTap: () {
              // 앱 정보 페이지로 이동
            },
          ),
        ],
      ),
    );
  }
}
