import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(
          const Duration(milliseconds: 100),
          (_) => setState(() {}),
        );
      }
    });
  }

  void _reset() {
    setState(() {
      _stopwatch
        ..stop()
        ..reset();
      _timer?.cancel();
    });
  }

  String _formattedTime() {
    final elapsed = _stopwatch.elapsed;
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final tenths = (elapsed.inMilliseconds % 1000 ~/ 100).toString();
    return '$hours:$minutes:$seconds.$tenths';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch Wawancara')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ukur durasi sesi atau peristiwa yang sedang diamati.',
              style: TextStyle(color: Color(0xFF71675C)),
            ),
            const SizedBox(height: 36),
            Card(
              color: const Color(0xFF2D241B),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(
                  _formattedTime(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _toggle,
              icon: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_stopwatch.isRunning ? 'Jeda' : 'Mulai'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
