import 'package:flutter/material.dart';

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  DateTime? _birthDate;
  DateTime? _referenceDate;

  Future<void> _pickDateTime({required bool birthDate}) async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: birthDate
          ? (_birthDate ?? DateTime(2000))
          : (_referenceDate ?? DateTime.now()),
    );
    if (selected == null || !mounted) return;
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: birthDate
          ? TimeOfDay.fromDateTime(_birthDate ?? DateTime(2000))
          : TimeOfDay.fromDateTime(_referenceDate ?? DateTime.now()),
    );
    if (selectedTime == null) return;
    final selectedDateTime = DateTime(
      selected.year,
      selected.month,
      selected.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      if (birthDate) {
        _birthDate = selectedDateTime;
      } else {
        _referenceDate = selectedDateTime;
      }
    });
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String? _ageResult() {
    if (_birthDate == null || _referenceDate == null) return null;
    if (_birthDate!.isAfter(_referenceDate!)) {
      return 'Tanggal lahir melebihi tanggal acuan.';
    }

    var years = _referenceDate!.year - _birthDate!.year;
    var months = _referenceDate!.month - _birthDate!.month;
    var days = _referenceDate!.day - _birthDate!.day;
    var hours = _referenceDate!.hour - _birthDate!.hour;
    var minutes = _referenceDate!.minute - _birthDate!.minute;
    var seconds = _referenceDate!.second - _birthDate!.second;
    if (seconds < 0) {
      minutes--;
      seconds += 60;
    }
    if (minutes < 0) {
      hours--;
      minutes += 60;
    }
    if (hours < 0) {
      days--;
      hours += 24;
    }
    if (days < 0) {
      months--;
      final previousMonth = DateTime(
        _referenceDate!.year,
        _referenceDate!.month,
        0,
      );
      days += previousMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    return '$years tahun, $months bulan, $days hari, '
        '$hours jam, $minutes menit, $seconds detik';
  }

  @override
  Widget build(BuildContext context) {
    final result = _ageResult();
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Umur Presisi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Gunakan tanggal acuan untuk membaca umur absolut responden.',
            style: TextStyle(color: Color(0xFF71675C)),
          ),
          const SizedBox(height: 20),
          _dateField(
            label: 'Tanggal lahir',
            value: _birthDate,
            onTap: () => _pickDateTime(birthDate: true),
          ),
          const SizedBox(height: 12),
          _dateField(
            label: 'Tanggal acuan',
            value: _referenceDate,
            onTap: () => _pickDateTime(birthDate: false),
          ),
          if (result != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Umur responden'),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: const Color(0xFF8E5D13),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event_outlined, color: Color(0xFF8E5D13)),
        title: Text(label),
        subtitle: Text(_dateLabel(value)),
        trailing: const Icon(Icons.edit_calendar_outlined),
        onTap: onTap,
      ),
    );
  }
}
