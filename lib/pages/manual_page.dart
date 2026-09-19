import 'package:flutter/material.dart';
import 'login_page.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({this.embedded = false, super.key});

  final bool embedded;

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);
    if (embedded) return content;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/menu_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(child: content),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 90),
          children: [
            const SizedBox(height: 10),
            const Text(
              'Bantuan',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF904E1D),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Panduan penggunaan dan etika riset lapangan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBA4B42),
              ),
            ),
            const SizedBox(height: 24),
            const _ManualSection(
              number: '1',
              title: 'Data Kelompok',
              description:
                  'Lihat anggota kelompok dan pembagian tugas penelitian.',
            ),
            const _ManualSection(
              number: '2',
              title: 'Menu Perhitungan',
              description:
                  'Pakai kalkulator operasi, pengecek ganjil/genap, atau total angka.',
            ),
            const _ManualSection(
              number: '3',
              title: 'Jurnal Riset',
              description:
                  'Tambah, ubah, dan hapus catatan responden atau observasi.',
            ),
            const _ManualSection(
              number: '4',
              title: 'Konversi Umur',
              description:
                  'Masukkan tanggal lahir dan tanggal acuan untuk menghitung umur.',
            ),
            const _ManualSection(
              number: '5',
              title: 'Kalender Weton & Saka Bali',
              description:
                  'Catat konteks kalender lokal bersama tanggal Masehi dan sumber keterangannya.',
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5A638)),
              ),
              child: const Text(
                'Etika riset: minta informed consent, gunakan kode responden bila diperlukan, dan jelaskan tujuan penggunaan data.',
                style: TextStyle(color: Color(0xFF3E2712), height: 1.35),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB84A41),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualSection extends StatelessWidget {
  const _ManualSection({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFE5B95C),
            foregroundColor: const Color(0xFF2D241B),
            child: Text(number),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(description),
          ),
        ),
      ),
    );
  }
}
