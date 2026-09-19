import 'package:flutter/material.dart';
import 'calculator_page.dart';
import 'digit_sum_page.dart';
import 'main_menu_page.dart';
import 'manual_page.dart';
import 'odd_even_page.dart';
import 'stopwatch_page.dart';

class CalculationMenuPage extends StatelessWidget {
  const CalculationMenuPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Kalkulator Operasi',
        'Tambah, kurang, kali, dan bagi untuk perhitungan lapangan.',
        Icons.calculate_outlined,
        () => _open(context, const CalculatorPage()),
      ),
      (
        'Ganjil / Genap',
        'Kelompokkan ID responden untuk kebutuhan sampling.',
        Icons.numbers_outlined,
        () => _open(context, const OddEvenPage()),
      ),
      (
        'Total Angka',
        'Jumlahkan angka atau skor kuesioner dengan cepat.',
        Icons.functions,
        () => _open(context, const DigitSumPage()),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Asset matching app theme
          Positioned.fill(
            child: Image.asset(
              'assets/images/calendar_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main Content Area
          SafeArea(
            child: Column(
              children: [
                // Top Header Bar
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Menu Perhitungan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),

                // Content List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    children: [
                      const Text(
                        'Pilih alat perhitungan yang diperlukan saat riset lapangan.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...items.map(
                        (item) => _CustomCalcCard(
                          title: item.$1,
                          subtitle: item.$2,
                          icon: item.$3,
                          onTap: item.$4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Full-width Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFFE29F2B),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Home',
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const MainMenuPage()),
                          (route) => false,
                        );
                      },
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.access_time_rounded,
                      label: 'Stopwatch',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const StopwatchPage()),
                        );
                      },
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.info_outline_rounded,
                      label: 'Help',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ManualPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF3E2712),
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF3E2712),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomCalcCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CustomCalcCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5A638),
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE4B5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF3D2E1E),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Right Chevron
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFE5A638),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
