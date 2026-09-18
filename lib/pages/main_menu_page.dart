import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
import 'age_calculator_page.dart';
import 'calculator_page.dart';
import 'culture_info_page.dart';
import 'digit_sum_page.dart';
import 'journal_page.dart';
import 'odd_even_page.dart';
import 'stopwatch_page.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  static const _titles = ['Jurnal', 'Hitung', 'Observasi', 'Kultur & Info'];

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _journalTab() {
    return const JournalPage(embedded: true);
  }

  Widget _calculateTab() {
    final menuItems = [
      (
        'Kalkulator operasi',
        'Hitung kebutuhan logistik dan angka lapangan',
        Icons.calculate_outlined,
        () => _openPage(context, const CalculatorPage()),
      ),
      (
        'Ganjil / genap',
        'Bagi ID responden ke kelompok sampling',
        Icons.numbers_outlined,
        () => _openPage(context, const OddEvenPage()),
      ),
      (
        'Total angka',
        'Jumlahkan skor kuesioner dengan cepat',
        Icons.functions,
        () => _openPage(context, const DigitSumPage()),
      ),
    ];
    return _toolList('Alat hitung lapangan', menuItems);
  }

  Widget _observationsTab() {
    return _toolList('Observasi', [
      (
        'Stopwatch wawancara',
        'Ukur durasi wawancara dan peristiwa',
        Icons.timer_outlined,
        () => _openPage(context, const StopwatchPage()),
      ),
      (
        'Konversi umur presisi',
        'Hitung umur responden sampai hari',
        Icons.cake_outlined,
        () => _openPage(context, const AgeCalculatorPage()),
      ),
    ]);
  }

  Widget _cultureTab() {
    return _toolList('Konteks waktu dan bantuan', [
      (
        'Weton dan kalender lokal',
        'Catat konteks budaya dari narasumber',
        Icons.calendar_month_outlined,
        () => _openPage(context, const CultureInfoPage()),
      ),
      (
        'Bantuan dan etika riset',
        'Panduan informed consent dan SOP lapangan',
        Icons.volunteer_activism_outlined,
        () => _openPage(context, const CultureInfoPage()),
      ),
    ]);
  }

  Widget _toolList(
    String heading,
    List<(String, String, IconData, VoidCallback)> items,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D241B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pilih alat yang dibutuhkan untuk kegiatan hari ini.',
          style: TextStyle(color: Color(0xFF71675C)),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6A9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.$3, color: const Color(0xFF8E5D13)),
              ),
              title: Text(
                item.$1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D241B),
                ),
              ),
              subtitle: Text(item.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: item.$4,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: _titles[_selectedIndex],
        showBackButton: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _journalTab(),
          _calculateTab(),
          _observationsTab(),
          _cultureTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Jurnal',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Hitung',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Observasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Kultur & Info',
          ),
        ],
      ),
    );
  }
}
