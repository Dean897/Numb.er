import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
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
        'Lihat anggota dan pembagian tugas kelompok.',
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
        'Menu Perhitungan',
        'Kalkulator operasi, ganjil/genap, dan total angka.',
        Icons.calculate_outlined,
        () => _openPage(const CalculationMenuPage()),
      ),
      (
        'Jurnal Riset',
        'Tambah, ubah, lihat, dan hapus catatan penelitian.',
        Icons.menu_book_outlined,
        () => _openPage(const JournalPage()),
      ),
      (
        'Konversi Tanggal Lahir',
        'Hitung umur dalam tahun, bulan, hari, jam, menit, dan detik.',
        Icons.cake_outlined,
        () => _openPage(const AgeCalculatorPage()),
      ),
      (
        'Kalender Weton & Saka Bali',
        'Catat dan pahami konteks kalender budaya lokal.',
        Icons.calendar_month_outlined,
        () => _openPage(const CultureInfoPage()),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        Text(
          'KalaRiset',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D241B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pilih fitur untuk mendukung kegiatan riset lapangan.',
          style: TextStyle(color: Color(0xFF71675C)),
        ),
        const SizedBox(height: 20),
        ...menuItems.asMap().entries.map(
          (entry) => _MainMenuCard(
            number: entry.key + 1,
            title: entry.value.$1,
            description: entry.value.$2,
            icon: entry.value.$3,
            onTap: entry.value.$4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_homePage(), const StopwatchPage(), const ManualPage()];
    const titles = ['Halaman Utama', 'Stopwatch', 'Manual & Bantuan'];

    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: titles[_selectedIndex],
        showBackButton: false,
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Utama',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Stopwatch',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Manual',
          ),
        ],
      ),
    );
  }
}

class _MainMenuCard extends StatelessWidget {
  const _MainMenuCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final int number;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFE6A9),
          foregroundColor: const Color(0xFF8E5D13),
          child: Icon(icon),
        ),
        title: Text(
          '$number. $title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D241B),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(description),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
