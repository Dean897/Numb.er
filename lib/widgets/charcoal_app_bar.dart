import 'package:flutter/material.dart';
import '../pages/login_page.dart';

AppBar buildCharcoalAppBar(
  BuildContext context, {
  required String title,
  bool showBackButton = true,
}) {
  return AppBar(
    backgroundColor: const Color(0xFF2D3142),
    foregroundColor: Colors.white,
    elevation: 2,
    automaticallyImplyLeading: false,
    leading: showBackButton
        ? IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )
        : null,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        tooltip: 'Keluar aplikasi',
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
        ),
      ),
    ],
  );
}
