import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
import 'calculator_page.dart';
import 'digit_sum_page.dart';
import 'odd_even_page.dart';

class CalculationMenuPage extends StatelessWidget {
  const CalculationMenuPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Kalkulator operasi',
        'Tambah, kurang, kali, dan bagi untuk perhitungan lapangan.',
        Icons.calculate_outlined,
        () => _open(context, const CalculatorPage()),
      ),
      (
        'Ganjil / genap',
        'Kelompokkan ID responden untuk kebutuhan sampling.',
        Icons.numbers_outlined,
        () => _open(context, const OddEvenPage()),
      ),
      (
        'Total angka',
        'Jumlahkan angka atau skor kuesioner dengan cepat.',
        Icons.functions,
        () => _open(context, const DigitSumPage()),
      ),
    ];

    return Scaffold(
      appBar: buildCharcoalAppBar(context, title: 'Menu Perhitungan'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Pilih alat perhitungan yang diperlukan saat riset lapangan.',
            style: TextStyle(color: Color(0xFF71675C)),
          ),
          const SizedBox(height: 20),
          ...items.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFFFE6A9),
                  foregroundColor: const Color(0xFF8E5D13),
                  child: Icon(item.$3),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item.$2),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: item.$4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
