import 'package:flutter/material.dart';

class CultureInfoPage extends StatelessWidget {
  const CultureInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kultur & Info')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Catat konteks lokal dengan teliti sebelum diterjemahkan ke laporan.',
            style: TextStyle(color: Color(0xFF71675C)),
          ),
          const SizedBox(height: 20),
          _InfoSection(
            icon: Icons.calendar_month_outlined,
            title: 'Konteks kalender lokal',
            children: const [
              'Weton, Saka Bali, dan Hijriah sebaiknya dicatat bersama tanggal Masehi serta sumber keterangan warga.',
              'Contoh catatan: Jumat Kliwon, 12 Januari 2024, disebutkan oleh narasumber saat wawancara.',
            ],
          ),
          const SizedBox(height: 14),
          _InfoSection(
            icon: Icons.volunteer_activism_outlined,
            title: 'Etika sebelum mencatat',
            children: const [
              'Minta informed consent sebelum merekam, memotret, atau menyimpan identitas narasumber.',
              'Gunakan kode responden jika nama asli tidak diperlukan untuk analisis.',
              'Jelaskan tujuan riset, cara penggunaan data, dan hak narasumber untuk berhenti.',
            ],
          ),
          const SizedBox(height: 14),
          _InfoSection(
            icon: Icons.fact_check_outlined,
            title: 'Checklist sesi lapangan',
            children: const [
              'Pastikan lokasi, waktu observasi, dan konteks kejadian tercatat.',
              'Pisahkan fakta hasil pengamatan dari interpretasi peneliti.',
              'Tinjau ulang jurnal sebelum meninggalkan lokasi.',
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<String> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF8E5D13)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D241B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $text'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
