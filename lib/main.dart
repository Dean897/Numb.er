import 'package:flutter/material.dart';

import 'pages/login_page.dart';

void main() {
  runApp(const TerminalMathApp());
}

class TerminalMathApp extends StatelessWidget {
  const TerminalMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryDarkGray = Color(0xFF2D3142);
    const bgLightGray = Color(0xFFF4F4F6);
    const borderGray = Color(0xFFE0E0E4);

    return MaterialApp(
      title: 'Terminal Math & Team Utility',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryDarkGray,
          brightness: Brightness.light,
          surface: bgLightGray,
        ),
        scaffoldBackgroundColor: bgLightGray,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDarkGray,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: borderGray, width: 1),
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
            borderSide: const BorderSide(color: borderGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: borderGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryDarkGray, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryDarkGray,
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
