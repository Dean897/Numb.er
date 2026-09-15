import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
import 'calculator_page.dart';
import 'digit_sum_page.dart';
import 'group_data_page.dart';
import 'odd_even_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static const members = [
    ('Deandra', '124240144', 'Programmer'),
    ('Habrian', '124240126', 'Tester, UI/UX'),
    ('Titan', '124240152', 'UI/UX'),
  ];

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      (
        'Data Kelompok',
        'Lihat anggota dan pembagian tugas',
        Icons.groups_outlined,
        () => _openPage(context, const GroupDataPage(members: members)),
      ),
      (
        'Kalkulator',
        'Tambah, kurang, kali, dan bagi',
        Icons.calculate_outlined,
        () => _openPage(context, const CalculatorPage()),
      ),
      (
        'Ganjil / Genap',
        'Periksa jenis sebuah bilangan',
        Icons.numbers_outlined,
        () => _openPage(context, const OddEvenPage()),
      ),
      (
        'Total Angka',
        'Jumlahkan setiap digit angka',
        Icons.functions,
        () => _openPage(context, const DigitSumPage()),
      ),
    ];

    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Menu Utama',
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Numb.er',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pilih aktivitas yang ingin dijalankan.',
            style: TextStyle(color: Color(0xFF666666)),
          ),
          const SizedBox(height: 20),
          ...menuItems.map(
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
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.$3, color: const Color(0xFF2D3142)),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                subtitle: Text(
                  item.$2,
                  style: const TextStyle(color: Color(0xFF666666)),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF888888),
                ),
                onTap: item.$4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
