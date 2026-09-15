import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
import '../widgets/result_card.dart';

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
      appBar: buildCharcoalAppBar(
        context,
        title: 'Total Jumlah Angka',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Deretan angka tanpa spasi',
                hintText: 'Contoh: 852',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _sum,
              icon: const Icon(Icons.functions),
              label: const Text('Jumlahkan'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 20),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_total != null) ...[
              const SizedBox(height: 24),
              ResultCard(label: 'Proses', value: _process!),
              const SizedBox(height: 12),
              ResultCard(label: 'Total', value: '$_total'),
            ],
          ],
        ),
      ),
    );
  }
}
