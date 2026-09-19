import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'manual_page.dart';
import 'stopwatch_page.dart';

class DigitSumPage extends StatefulWidget {
  const DigitSumPage({super.key});

  @override
  State<DigitSumPage> createState() => _DigitSumPageState();
}

class _DigitSumPageState extends State<DigitSumPage> {
  final _controller = TextEditingController();
  String? _error;
  String? _process;
  int? _total;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sum() {
    final input = _controller.text.trim();
    if (!RegExp(r'^\d+$').hasMatch(input)) {
      setState(() {
        _error = 'Masukkan deretan angka tanpa spasi.';
        _process = null;
        _total = null;
      });
      return;
    }
    final digits = input.split('').map(int.parse).toList();
    setState(() {
      _error = null;
      _process = digits.join(' + ');
      _total = digits.reduce((sum, digit) => sum + digit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
                const SizedBox(height: 12),
                // Top Header Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Total Jumlah Angka',
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

                // Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    children: [
                      _buildFormCard(),
                      if (_total != null || _error != null) ...[
                        const SizedBox(height: 16),
                        _buildResultCard(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation Bar
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
                  const Text(
                    'Deretan Angka (Tanpa Spasi)',
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
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D241B),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: 852',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _sum,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3963B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Jumlahkan',
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
              Text(
                _error != null ? 'Peringatan' : 'Hasil Penjumlahan',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                )
              else ...[
                // Process Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Proses',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _process!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC98A2E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Total Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_total',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC98A2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

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

