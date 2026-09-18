import 'package:flutter/material.dart';

class CultureInfoPage extends StatefulWidget {
  const CultureInfoPage({super.key});

  @override
  State<CultureInfoPage> createState() => _CultureInfoPageState();
}

class _CultureInfoPageState extends State<CultureInfoPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime? _convertedDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: _selectedDate,
    );
    if (picked == null) return;
    setState(() {
      _selectedDate = picked;
      _convertedDate = null;
    });
  }

  void _convert() {
    setState(() => _convertedDate = _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final convertedDate = _convertedDate;
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Kalender')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Pilih satu tanggal Masehi untuk melihat padanan Hijriah, Weton, dan Saka Bali.',
            style: TextStyle(color: Color(0xFF71675C)),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.event_outlined,
                color: Color(0xFF8E5D13),
              ),
              title: const Text('Tanggal Masehi'),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _convert,
            icon: const Icon(Icons.sync_alt),
            label: const Text('Konversikan tanggal'),
          ),
          if (convertedDate != null) ...[
            const SizedBox(height: 24),
            _ResultCard(
              icon: Icons.mosque_outlined,
              title: 'Kalender Hijriah',
              value: _hijriDate(convertedDate),
            ),
            _ResultCard(
              icon: Icons.calendar_view_week_outlined,
              title: 'Weton Jawa',
              value: _wetonDate(convertedDate),
            ),
            _ResultCard(
              icon: Icons.temple_hindu_outlined,
              title: 'Saka Bali',
              value: _sakaBaliDate(convertedDate),
            ),
            const SizedBox(height: 8),
            const Text(
              'Catatan: tanggal Hijriah dapat berbeda satu hari berdasarkan metode rukyat atau hisab. Tahun Saka Bali dihitung berdasarkan pergantian Nyepi.',
              style: TextStyle(fontSize: 12, color: Color(0xFF71675C)),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _hijriDate(DateTime date) {
  final hijri = _toHijri(date);
  const months = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];
  return '${hijri.day} ${months[hijri.month - 1]} ${hijri.year} H';
}

String _wetonDate(DateTime date) {
  const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  const weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  final daysFromReference = date.difference(DateTime(2024, 1, 1)).inDays;
  final pasaranIndex = (daysFromReference + 3) % 5;
  final safePasaranIndex = pasaranIndex < 0 ? pasaranIndex + 5 : pasaranIndex;
  return '${weekdays[date.weekday - 1]} ${pasaran[safePasaranIndex]}';
}

String _sakaBaliDate(DateTime date) {
  final nyepi = _nyepiDate(date.year);
  final sakaYear = date.isBefore(nyepi) ? date.year - 79 : date.year - 78;
  return '${date.day} ${_balineseMonth(date.month)} $sakaYear Saka';
}

DateTime _nyepiDate(int year) {
  const nyepiDates = <int, int>{
    2024: 11,
    2025: 29,
    2026: 19,
    2027: 8,
    2028: 26,
    2029: 15,
    2030: 5,
  };
  return DateTime(year, 3, nyepiDates[year] ?? 21);
}

String _balineseMonth(int month) {
  const months = [
    'Kasa',
    'Karo',
    'Katiga',
    'Kapat',
    'Kalima',
    'Kanem',
    'Kapitu',
    'Kawolu',
    'Kasanga',
    'Kadasa',
    'Desta',
    'Sada',
  ];
  return months[month - 1];
}

_HijriDate _toHijri(DateTime date) {
  final julianDay = _julianDay(date.year, date.month, date.day);
  var l = julianDay - 1_948_440 + 10_632;
  final n = ((l - 1) / 10_631).floor();
  l = l - 10_631 * n + 354;
  final j =
      (((10_985 - l) / 5_316).floor() * ((50 * l) / 17_719).floor()) +
      ((l / 5_670).floor() * ((43 * l) / 15_238).floor());
  l =
      l -
      (((30 - j) / 15).floor() * ((17_719 * j) / 50).floor()) -
      ((j / 16).floor() * ((15_238 * j) / 43).floor()) +
      29;
  final month = ((24 * l) / 709).floor();
  final day = l - ((709 * month) / 24).floor();
  final year = 30 * n + j - 30;
  return _HijriDate(year, month, day);
}

int _julianDay(int year, int month, int day) {
  final a = ((14 - month) / 12).floor();
  final y = year + 4_800 - a;
  final m = month + 12 * a - 3;
  return day +
      ((153 * m + 2) / 5).floor() +
      365 * y +
      (y / 4).floor() -
      (y / 100).floor() +
      (y / 400).floor() -
      32_045;
}

class _HijriDate {
  const _HijriDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8E5D13)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
