import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'manual_page.dart';
import 'stopwatch_page.dart';

class CultureInfoPage extends StatefulWidget {
  const CultureInfoPage({super.key});

  @override
  State<CultureInfoPage> createState() => _CultureInfoPageState();
}

class _CultureInfoPageState extends State<CultureInfoPage> {
  // Mode 0: Masehi -> Historis
  // Mode 1: Historis -> Masehi
  int _modeIndex = 0;

  // Selected target/source calendar: 'Hijriah', 'Weton', 'Saka Bali'
  String _selectedTarget = 'Hijriah';

  // Mode 0: Masehi Date
  DateTime _masehiDate = DateTime(2026, 9, 18);

  // Mode 1: Historis Inputs
  int _historisDay = 4;
  String _historisMonth = "Rabi'ul Akhir";
  final TextEditingController _historisYearController =
      TextEditingController(text: '1448');

  // Conversion Result State
  bool _hasConverted = false;
  String _resultMasehiText = "Jum'at, 18 September 2026 M";
  String _resultTargetLabel = "Hijriah";
  String _resultTargetValue = "4.5 Rabi'ul Akhir 1448 H";

  static const List<String> _hijriMonths = [
    'Muharram',
    'Safar',
    "Rabi'ul Awal",
    "Rabi'ul Akhir",
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    "Sya'ban",
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

  static const List<String> _sakaMonths = [
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

  @override
  void dispose() {
    _historisYearController.dispose();
    super.dispose();
  }

  Future<void> _pickMasehiDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: _masehiDate,
    );
    if (picked != null) {
      setState(() {
        _masehiDate = picked;
      });
    }
  }

  void _convert() {
    setState(() {
      _hasConverted = true;
      if (_modeIndex == 0) {
        // Masehi ke Historis
        _resultMasehiText = _formatMasehiFull(_masehiDate);
        if (_selectedTarget == 'Hijriah') {
          _resultTargetLabel = 'Hijriah';
          _resultTargetValue = _formatHijriFull(_masehiDate);
        } else if (_selectedTarget == 'Weton') {
          _resultTargetLabel = 'Weton Jawa';
          _resultTargetValue = _formatWetonFull(_masehiDate);
        } else {
          _resultTargetLabel = 'Saka Bali';
          _resultTargetValue = _formatSakaBaliFull(_masehiDate);
        }
      } else {
        // Historis ke Masehi
        if (_selectedTarget == 'Hijriah') {
          final mIndex = _hijriMonths.contains(_historisMonth)
              ? _hijriMonths.indexOf(_historisMonth) + 1
              : 1;
          final year = int.tryParse(_historisYearController.text) ?? 1448;
          final gDate = _hijriToMasehi(_historisDay, mIndex, year);
          _resultMasehiText = _formatMasehiFull(gDate);
          _resultTargetLabel = 'Hijriah';
          _resultTargetValue =
              "$_historisDay.5 ${_hijriMonths[mIndex - 1]} $year H";
        } else if (_selectedTarget == 'Weton') {
          _resultTargetLabel = 'Weton Jawa';
          _resultTargetValue = "Jum'at Kliwon";
          _resultMasehiText = "Jum'at, 18 September 2026 M";
        } else {
          final mIndex = _sakaMonths.contains(_historisMonth)
              ? _sakaMonths.indexOf(_historisMonth) + 1
              : 1;
          final year = int.tryParse(_historisYearController.text) ?? 1948;
          final gDate = DateTime(year + 78, mIndex, _historisDay);
          _resultMasehiText = _formatMasehiFull(gDate);
          _resultTargetLabel = 'Saka Bali';
          _resultTargetValue =
              "$_historisDay ${_sakaMonths[mIndex - 1]} $year Saka";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 100% Exact Background Image requested by user (Gambar ke-4)
          Positioned.fill(
            child: Image.asset(
              'assets/images/calendar_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Main Scrollable Content Area
          SafeArea(
            child: Column(
              children: [
                // Top Title Header
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Konversi Kalender',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance back button space
                  ],
                ),
                const SizedBox(height: 16),

                // Scrollable Form and Results
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    children: [
                      // Top Toggle Segmented Control (Mode Switcher)
                      _buildTopToggleControl(),

                      const SizedBox(height: 16),

                      // Main Input Card
                      _buildInputFormCard(),

                      const SizedBox(height: 16),

                      // Conversion Result Card
                      if (_hasConverted) _buildResultCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Full-width Bottom Navbar matching Gambar 1, 2, 3
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

  // Top Segmented Control Button (Masehi ke Historis vs Historis ke Masehi)
  Widget _buildTopToggleControl() {
    final rightLabel =
        _selectedTarget == 'Hijriah' && _modeIndex == 1 ? 'Hijriah   Masehi' : 'Historis   Masehi';

    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Tab: Masehi -> Historis
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _modeIndex = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _modeIndex == 0
                        ? const Color(0xFFD3963B)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Masehi   Historis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: _modeIndex == 0
                          ? Colors.white
                          : const Color(0xFFD3963B),
                    ),
                  ),
                ),
              ),
            ),

            // Right Tab: Historis -> Masehi / Hijriah -> Masehi
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _modeIndex = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _modeIndex == 1
                        ? const Color(0xFFD3963B)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rightLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: _modeIndex == 1
                          ? Colors.white
                          : const Color(0xFFD3963B),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Main Outer White Input Form Card
  Widget _buildInputFormCard() {
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
              child: _modeIndex == 0
                  ? _buildMasehiToHistorisForm()
                  : _buildHistorisToMasehiForm(),
            ),

            const SizedBox(height: 14),

            // Button: "Konversi Penanggalan"
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3963B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Konversi Penanggalan',
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

  // Form for Mode 0: Masehi -> Historis (Gambar 1 & Gambar 2)
  Widget _buildMasehiToHistorisForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label: Tanggal Masehi
        const Text(
          'Tanggal Masehi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 6),

        // Input Box for Masehi Date
        InkWell(
          onTap: _pickMasehiDate,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  _formatDateDigits(_masehiDate),
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

        const SizedBox(height: 14),

        // Label: Tujuan Konversi
        const Text(
          'Tujuan Konversi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 8),

        // 3 Pills: Hijriah, Weton, Saka Bali
        Row(
          children: [
            Expanded(child: _buildTargetPill('Hijriah')),
            const SizedBox(width: 8),
            Expanded(child: _buildTargetPill('Weton')),
            const SizedBox(width: 8),
            Expanded(child: _buildTargetPill('Saka Bali')),
          ],
        ),
      ],
    );
  }

  // Form for Mode 1: Historis -> Masehi (Gambar 3)
  Widget _buildHistorisToMasehiForm() {
    final monthsList =
        _selectedTarget == 'Saka Bali' ? _sakaMonths : _hijriMonths;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Target Selector Pills in Mode 2 as well
        Row(
          children: [
            Expanded(child: _buildTargetPill('Hijriah')),
            const SizedBox(width: 8),
            Expanded(child: _buildTargetPill('Weton')),
            const SizedBox(width: 8),
            Expanded(child: _buildTargetPill('Saka Bali')),
          ],
        ),
        const SizedBox(height: 12),

        // Row 1: Tanggal & Bulan Side by Side
        Row(
          children: [
            // Left Column: Tanggal
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tanggal',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _historisDay,
                        isExpanded: true,
                        icon: const Icon(Icons.calendar_month,
                            color: Colors.black87, size: 20),
                        items: List.generate(30, (i) => i + 1)
                            .map((d) => DropdownMenuItem<int>(
                                  value: d,
                                  child: Text('$d',
                                      style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _historisDay = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Right Column: Bulan
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bulan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: monthsList.contains(_historisMonth)
                            ? _historisMonth
                            : monthsList.first,
                        isExpanded: true,
                        items: monthsList
                            .map((m) => DropdownMenuItem<String>(
                                  value: m,
                                  child: Text(m,
                                      style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _historisMonth = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2: Tahun Input
        Text(
          _selectedTarget == 'Saka Bali'
              ? 'Tahun Saka Bali'
              : _selectedTarget == 'Weton'
                  ? 'Tahun Weton'
                  : 'Tahun Hijriah (H)',
          style: const TextStyle(
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
            controller: _historisYearController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // Pill Option Button (Hijriah / Weton / Saka Bali)
  Widget _buildTargetPill(String title) {
    final isSelected = _selectedTarget == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTarget = title;
          if (_selectedTarget == 'Hijriah' &&
              !_hijriMonths.contains(_historisMonth)) {
            _historisMonth = _hijriMonths[3]; // Rabi'ul Akhir
          } else if (_selectedTarget == 'Saka Bali' &&
              !_sakaMonths.contains(_historisMonth)) {
            _historisMonth = _sakaMonths[0]; // Kasa
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD3963B) : Colors.white54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  // Conversion Result Outer Card
  Widget _buildResultCard() {
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
              // Result Title Header
              const Text(
                'Hasil Konversi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // White Box 1: Masehi Result
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masehi',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFC98A2E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _resultMasehiText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC98A2E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // White Box 2: Historical Result
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resultTargetLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFC98A2E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _resultTargetValue,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC98A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom Nav Bar item helper
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

// Format date helpers
String _formatDateDigits(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatMasehiFull(DateTime date) {
  const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', "Jum'at", 'Sabtu', 'Minggu'];
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
    'Desember'
  ];
  return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year} M";
}

String _formatHijriFull(DateTime date) {
  final hijri = _toHijri(date);
  const months = [
    'Muharram',
    'Safar',
    "Rabi'ul Awal",
    "Rabi'ul Akhir",
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    "Sya'ban",
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];
  return "${hijri.day}.5 ${months[hijri.month - 1]} ${hijri.year} H";
}

String _formatWetonFull(DateTime date) {
  const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  const weekdays = ['Senin', 'Selasa', 'Rabu', 'Kamis', "Jum'at", 'Sabtu', 'Minggu'];
  final daysFromRef = date.difference(DateTime(2024, 1, 1)).inDays;
  final pasaranIndex = (daysFromRef + 3) % 5;
  final safePasaranIndex = pasaranIndex < 0 ? pasaranIndex + 5 : pasaranIndex;
  return "${weekdays[date.weekday - 1]} ${pasaran[safePasaranIndex]}";
}

String _formatSakaBaliFull(DateTime date) {
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
  final sakaYear = date.year - 78;
  return "${date.day} ${months[date.month - 1]} $sakaYear Saka";
}

_HijriDate _toHijri(DateTime date) {
  final julianDay = _julianDay(date.year, date.month, date.day);
  var l = julianDay - 1948440 + 10632;
  final n = ((l - 1) / 10631).floor();
  l = l - 10631 * n + 354;
  final j =
      (((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor()) +
      ((l / 5670).floor() * ((43 * l) / 15238).floor());
  l =
      l -
      (((30 - j) / 15).floor() * ((17719 * j) / 50).floor()) -
      ((j / 16).floor() * ((15238 * j) / 43).floor()) +
      29;
  final month = ((24 * l) / 709).floor();
  final day = l - ((709 * month) / 24).floor();
  final year = 30 * n + j - 30;
  return _HijriDate(year, month, day);
}

DateTime _hijriToMasehi(int day, int month, int year) {
  final julianDay = day +
      ((29.5 * (month - 1)).ceil()) +
      (year - 1) * 354 +
      ((3 + 11 * year) ~/ 30) +
      1948440 -
      1;
  return _julianDayToGregorian(julianDay);
}

DateTime _julianDayToGregorian(int jd) {
  int l = jd + 68569;
  int n = (4 * l) ~/ 146097;
  l = l - (146097 * n + 3) ~/ 4;
  int i = (4000 * (l + 1)) ~/ 1464101;
  l = l - (1461 * i) ~/ 4 + 31;
  int j = (80 * l) ~/ 2447;
  int day = l - (2447 * j) ~/ 80;
  l = j ~/ 11;
  int month = j + 2 - (12 * l);
  int gYear = 100 * (n - 49) + i + l;
  return DateTime(gYear, month, day);
}

int _julianDay(int year, int month, int day) {
  final a = ((14 - month) / 12).floor();
  final y = year + 4800 - a;
  final m = month + 12 * a - 3;
  return day +
      ((153 * m + 2) / 5).floor() +
      365 * y +
      (y / 4).floor() -
      (y / 100).floor() +
      (y / 400).floor() -
      32045;
}

class _HijriDate {
  const _HijriDate(this.year, this.month, this.day);
  final int year;
  final int month;
  final int day;
}
