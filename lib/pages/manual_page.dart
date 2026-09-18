import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
import 'login_page.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Manual & Bantuan',
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Panduan penggunaan KalaRiset',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D241B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gunakan aplikasi secara berurutan sesuai kebutuhan kegiatan riset.',
            style: TextStyle(color: Color(0xFF71675C)),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFFFFF4D6),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Etika riset: minta informed consent, gunakan kode responden bila diperlukan, dan jelaskan tujuan penggunaan data.',
              ),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
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
