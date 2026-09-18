import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const KalaRisetApp());
}

class KalaRisetApp extends StatelessWidget {
  const KalaRisetApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF2D241B);
    const amber = Color(0xFFC98A2E);
    const canvas = Color(0xFFF8F3E9);
    const border = Color(0xFFE5D8C4);

    return MaterialApp(
      title: 'KalaRiset',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: amber,
          brightness: Brightness.light,
          surface: canvas,
        ),
        scaffoldBackgroundColor: canvas,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: amber, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
