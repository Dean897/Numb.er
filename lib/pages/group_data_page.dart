import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'manual_page.dart';
import 'stopwatch_page.dart';

class GroupDataPage extends StatelessWidget {
  const GroupDataPage({required this.members, super.key});

  final List<(String, String, String)> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image Asset
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
                        'Data Kelompok 4',
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

                // Members List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge & Member Header
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC98A2E),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Anggota ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // White Inner Card for Details
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      Text(
                                        member.$1,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E1E1E),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(
                                          height: 1, color: Color(0xFFEEEEEE)),
                                      const SizedBox(height: 8),

                                      // NIM
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.badge_outlined,
                                            size: 18,
                                            color: Color(0xFFC98A2E),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'NIM: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                          Text(
                                            member.$2,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFC98A2E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      // Tugas
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.work_outline_rounded,
                                            size: 18,
                                            color: Color(0xFFC98A2E),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Tugas: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              member.$3,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFC98A2E),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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

