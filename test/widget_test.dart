import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_math_team_utility/data/journal_database.dart';
import 'package:terminal_math_team_utility/main.dart';

void main() {
  testWidgets('registrasi dan login memakai database', (
    WidgetTester tester,
  ) async {
    final database = await JournalDatabase.instance.database;
    await database.delete('users');
    await tester.pumpWidget(const KalaRisetApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Daftar').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'peneliti_test');
    await tester.enterText(find.byType(TextFormField).at(1), 'rahasia');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Daftar').last);
    await tester.pumpAndSettle();

    expect(find.text('KalaRiset'), findsWidgets);
    expect(find.textContaining('Data Kelompok'), findsOneWidget);
    expect(find.textContaining('Konversi Kalender'), findsOneWidget);
  });
}
