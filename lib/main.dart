import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/memo_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoProvider(),
      child: MaterialApp(
        title: 'Travel Memo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF2E7D32),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}