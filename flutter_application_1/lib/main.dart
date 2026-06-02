import 'package:flutter/material.dart';
import 'view/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booknity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      // Diarahkan ke MainScreen yang memegang Navbar utama
      home: const MainScreen(),
    );
  }
}