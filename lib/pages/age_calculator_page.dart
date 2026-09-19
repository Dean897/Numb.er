import 'dart:async';
import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'manual_page.dart';
import 'stopwatch_page.dart';

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _birthDate;
  bool _hasCalculated = false;
  Timer? _timer;

  // Age Breakdown
  int _years = 0;
  int _months = 0;
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
    );
    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_birthDate ?? DateTime(2000, 1, 1, 0, 0)),
    );

    final hour = selectedTime?.hour ?? 0;
    final minute = selectedTime?.minute ?? 0;

    setState(() {
      _birthDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );
      _hasCalculated = false;
      _timer?.cancel();
    });
  }

  void _updateAge() {
    if (_birthDate == null) return;

    final now = DateTime.now();
    var years = now.year - _birthDate!.year;
    var months = now.month - _birthDate!.month;
    var days = now.day - _birthDate!.day;
    var hours = now.hour - _birthDate!.hour;
    var minutes = now.minute - _birthDate!.minute;
    var seconds = now.second - _birthDate!.second;

    if (seconds < 0) {
      minutes--;
      seconds += 60;
    }
    if (minutes < 0) {
      hours--;
      minutes += 60;
    }
    if (hours < 0) {
      days--;
      hours += 24;
    }
    if (days < 0) {
      months--;
      final previousMonth = DateTime(now.year, now.month, 0);
      days += previousMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      _years = years < 0 ? 0 : years;
      _months = months < 0 ? 0 : months;
      _days = days < 0 ? 0 : days;
      _hours = hours < 0 ? 0 : hours;
      _minutes = minutes < 0 ? 0 : minutes;
      _seconds = seconds < 0 ? 0 : seconds;
      _hasCalculated = true;
    });
  }

  void _calculateAge() {
    if (_birthDate == null) return;
    _updateAge();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _updateAge();
    });
  }

  String _formatBirthDateLabel() {
    if (_birthDate == null) return '00/00/0000 00:00';
    final d = _birthDate!.day.toString().padLeft(2, '0');
    final m = _birthDate!.month.toString().padLeft(2, '0');
    final y = _birthDate!.year.toString();
    final hh = _birthDate!.hour.toString().padLeft(2, '0');
    final mm = _birthDate!.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $hh:$mm';
  }

  String _formatBirthDateHeader() {
    if (_birthDate == null) return '';
    const weekdays = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      "Jum'at",
      'Sabtu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final dayName = weekdays[_birthDate!.weekday % 7];
    final day = _birthDate!.day;
    final monthName = months[_birthDate!.month - 1];
    final year = _birthDate!.year;
    final hh = _birthDate!.hour.toString().padLeft(2, '0');
    final mm = _birthDate!.minute.toString().padLeft(2, '0');

    return 'Lahir pada: $dayName, $day $monthName $year - Pukul $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final nameText = _nameController.text.trim().isEmpty
        ? 'Nama'
        : _nameController.text.trim();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image Asset matching 100% exact style
          Positioned.fill(
            child: Image.asset(
              'assets/images/calendar_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main Scrollable Area
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
                        'Konversi Tanggal Lahir',
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
                      // Form Card
                      _buildFormCard(),

                      const SizedBox(height: 16),

                      // Result Card (Only visible after clicking "Hitung")
                      if (_hasCalculated) _buildResultCard(nameText),
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

  // Top Form Input Card
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5A638),
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Inner Golden Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEEB75B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label: Nama
                  const Text(
                    'Nama',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Label: Tanggal & Jam Lahir
                  const Text(
                    'Tanggal & Jam Lahir',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // DateTime Picker Button
                  InkWell(
                    onTap: _pickDateTime,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.black87,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _formatBirthDateLabel(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Helper note
                  const Text(
                    '*Biarkan jam pada 00:00 jika tidak tahu waktu kelahiran persisnya',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Button: "Hitung"
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _calculateAge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3963B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Hitung',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Result Card Grid (6 Boxes)
  Widget _buildResultCard(String name) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5A638),
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEEB75B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // (Nama)
              Text(
                '($name)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),

              // Lahir pada...
              Text(
                _formatBirthDateHeader(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 14),

              // 6 White Boxes Grid (3 columns x 2 rows)
              Row(
                children: [
                  Expanded(child: _buildGridBox('$_years', 'Tahun')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildGridBox('$_months', 'Bulan')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildGridBox('$_days', 'Hari')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildGridBox('$_hours', 'Jam')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildGridBox('$_minutes', 'Menit')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildGridBox('$_seconds', 'Detik')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for grid boxes
  Widget _buildGridBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC98A2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFC98A2E),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Nav Bar helper
  Widget _buildNavItem({
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
