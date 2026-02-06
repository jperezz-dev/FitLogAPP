import 'package:flutter/material.dart';
import 'package:fitlog_app/views/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App Material 3',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(0xFFFF5733)
      ),
      home: const Login(),
    );
  }
}