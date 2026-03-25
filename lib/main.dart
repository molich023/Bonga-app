// lib/main.dart
import 'package:flutter/material.dart';
import 'package:bonga_gropesa/screens/chat_screen.dart';
import 'package:bonga_gropesa/screens/rewards_screen.dart';
import 'package:bonga_gropesa/screens/profile_screen.dart';

void main() {
  runApp(const BongaApp());
}

class BongaApp extends StatelessWidget {
  const BongaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonga + GroPesa',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/chat',
      routes: {
        '/chat': (context) => const ChatScreen(),
        '/rewards': (context) => const RewardsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
