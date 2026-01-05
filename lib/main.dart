import 'package:flutter/material.dart';
import 'cots/design_system/colors.dart';
import 'cots/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Biar label debug ilang
      title: 'COTS App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        useMaterial3: true,
      ),
      home: const DashboardPage(), // Masuk langsung ke Dashboard
    );
  }
}