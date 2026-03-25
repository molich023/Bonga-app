import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const BongaApp());
}

class BongaApp extends StatelessWidget {
  const BongaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonga App',
      theme: ThemeData(
        primarySwatch: Colors.green, // Kenyan-inspired color
      ),
      home: const LoginScreen(),
    );
  }
}
