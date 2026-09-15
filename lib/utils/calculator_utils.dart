import 'package:flutter/services.dart';

const maxCalculatorDigits = 15;

class CalculatorDigitLimitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitCount = newValue.text.replaceAll(RegExp(r'[^0-9]'), '').length;
    return digitCount <= maxCalculatorDigits ? newValue : oldValue;
  }
}

String formatNumber(double value) {
  return value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
}
