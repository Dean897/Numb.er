import 'package:flutter/material.dart';
import '../utils/calculator_utils.dart';
import '../widgets/charcoal_app_bar.dart';
import '../widgets/result_card.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _firstController = TextEditingController();
  final _secondController = TextEditingController();
  String _operator = '+';
  String? _result;
  String? _error;

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _calculate() {
    final firstText = _firstController.text.trim();
    final secondText = _secondController.text.trim();
    final first = double.tryParse(firstText);
    final second = double.tryParse(secondText);
    final hasTooManyDigits = [firstText, secondText].any(
      (value) =>
          RegExp(r'[0-9]').allMatches(value).length > maxCalculatorDigits,
    );
    if (first == null || second == null || hasTooManyDigits) {
      setState(() {
        _error =
            'Masukkan angka yang valid dengan maksimal $maxCalculatorDigits digit per input.';
        _result = null;
      });
      return;
    }
    if (_operator == '/' && second == 0) {
      setState(() {
        _error = 'Pembagian dengan nol tidak diperbolehkan.';
        _result = null;
      });
      return;
    }

    final result = switch (_operator) {
      '+' => first + second,
      '-' => first - second,
      '*' => first * second,
      _ => first / second,
    };
    if (!result.isFinite) {
      setState(() {
        _error = 'Hasil terlalu besar untuk dihitung.';
        _result = null;
      });
      return;
    }
    setState(() {
      _error = null;
      _result =
          '${formatNumber(first)} $_operator ${formatNumber(second)} = '
          '${formatNumber(result)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCharcoalAppBar(
        context,
        title: 'Kalkulator',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _firstController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [CalculatorDigitLimitFormatter()],
            maxLength: 17,
            decoration: const InputDecoration(labelText: 'Angka pertama'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _secondController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [CalculatorDigitLimitFormatter()],
            maxLength: 17,
            decoration: const InputDecoration(labelText: 'Angka kedua'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _operator,
            decoration: const InputDecoration(labelText: 'Operator'),
            items: ['+', '-', '*', '/']
                .map(
                  (operator) =>
                      DropdownMenuItem(value: operator, child: Text(operator)),
                )
                .toList(),
            onChanged: (value) => setState(() => _operator = value!),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate),
            label: const Text('Hitung'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 20),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            ResultCard(label: 'Hasil', value: _result!),
          ],
        ],
      ),
    );
  }
}
