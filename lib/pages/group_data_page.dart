import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';

class GroupDataPage extends StatelessWidget {
  const GroupDataPage({required this.members, super.key});

  final List<(String, String, String)> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Data Kelompok 4',
        showBackButton: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ),
              title: Text(
                member.$1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              subtitle: Text(
                'NIM: ${member.$2}\nTugas: ${member.$3}',
                style: const TextStyle(color: Color(0xFF555555), height: 1.4),
              ),
            ),
          );
        },
      ),
    );
  }
}
