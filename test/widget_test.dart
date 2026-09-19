import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_math_team_utility/main.dart';

void main() {
  testWidgets('login menampilkan menu utama', (WidgetTester tester) async {
    await tester.pumpWidget(const KalaRisetApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), '12345');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk').last);
    await tester.pumpAndSettle();

    expect(find.text('KalaRiset'), findsWidgets);
    expect(find.textContaining('Data Kelompok'), findsOneWidget);
    expect(find.textContaining('Konversi Kalender'), findsOneWidget);
  });
}
