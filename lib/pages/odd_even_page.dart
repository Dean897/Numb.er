import 'package:flutter/material.dart';
import '../widgets/charcoal_app_bar.dart';
import '../widgets/result_card.dart';

class OddEvenPage extends StatefulWidget {
  const OddEvenPage({super.key});

  @override
  State<OddEvenPage> createState() => _OddEvenPageState();
}

class _OddEvenPageState extends State<OddEvenPage> {
  final _controller = TextEditingController();
  String? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final number = int.tryParse(_controller.text.trim());
    setState(() {
      _result = number == null
          ? 'Masukkan bilangan bulat yang valid.'
          : '$number adalah bilangan ${number.isEven ? 'GENAP' : 'GANJIL'}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Cek Ganjil / Genap',
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D241B),
              ),
              decoration: const InputDecoration(labelText: 'Masukkan bilangan'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _check,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Periksa'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              ResultCard(label: 'Hasil', value: _result!),
            ],
          ],
        ),
      ),
    );
  }
}
