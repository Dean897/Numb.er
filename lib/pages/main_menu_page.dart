import 'package:flutter/material.dart';
import 'age_calculator_page.dart';
import 'calculation_menu_page.dart';
import 'culture_info_page.dart';
import 'group_data_page.dart';
import 'journal_page.dart';
import 'manual_page.dart';
import 'stopwatch_page.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  void _openPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _homePage() {
    final menuItems = [
      (
        'Data Kelompok',
        'Lihat Anggota dan pembagian Tugas',
        Icons.groups_outlined,
        () => _openPage(
          const GroupDataPage(
            members: [
              ('Deandra', '124240144', 'Programmer'),
              ('Habrian', '124240126', 'Tester, UI/UX'),
              ('Titan', '124240152', 'UI/UX'),
            ],
          ),
        ),
      ),
      (
        'Kalkulator',
        'Operasi, Ganjil/Genap, & Total Angka',
        Icons.calculate_outlined,
        () => _openPage(const CalculationMenuPage()),
      ),
      (
        'Buku Jurnal Digital',
        'Lihat Anggota dan pembagian Tugas',
        Icons.bookmark_border_rounded,
        () => _openPage(const JournalPage()),
      ),
      (
        'Konversi Tanggal Lahir',
        'Menghitung Tanggal lahir',
        Icons.event_note_outlined,
        () => _openPage(const AgeCalculatorPage()),
      ),
      (
        'Konversi Kalender',
        'Weton, Saka Bali & Konversi Hijriah',
        Icons.calendar_today_outlined,
        () => _openPage(const CultureInfoPage()),
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 90),
          children: [
            const SizedBox(height: 10),
            const Text(
              'KalaRiset',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF904E1D),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih Aktivitas yang diinginkan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBA4B42),
              ),
            ),
            const SizedBox(height: 24),
            ...menuItems.map(
              (item) => _CustomMenuCard(
                title: item.$1,
                subtitle: item.$2,
                icon: item.$3,
                onTap: item.$4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? const Color(0xFF3E2712)
        : const Color(0xFF7A5B36);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isSelected ? 28 : 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homePage(),
      const StopwatchPage(embedded: true),
      const ManualPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 100% Exact Menu Background Image Asset (Expands to full desktop width)
          Positioned.fill(
            child: Image.asset(
              'assets/images/menu_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main Page View Overlay
          SafeArea(
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),

          // Full-width Bottom Navbar matching Gambar 2
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 68,
              decoration: const BoxDecoration(color: Color(0xFFE29F2B)),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.access_time_rounded,
                      label: 'Stopwatch',
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.info_outline_rounded,
                      label: 'Help',
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
}

class _CustomMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CustomMenuCard({
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
        border: Border.all(color: const Color(0xFFE5A638), width: 2.5),
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
                // Left Icon Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE4B5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF3D2E1E), size: 26),
                ),
                const SizedBox(width: 14),

                // Center Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
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

                // Right Chevron Icon
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFE5A638),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
