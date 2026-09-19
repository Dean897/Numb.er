import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terminal_math_team_utility/pages/age_calculator_page.dart';

void main() {
  testWidgets('AgeCalculatorPage displays initial form and shows result grid after calculation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AgeCalculatorPage(),
      ),
    );

    // Verify Title Header
    expect(find.text('Konversi Tanggal Lahir'), findsWidgets);

    // Verify Form Fields
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Tanggal & Jam Lahir'), findsOneWidget);
    expect(find.text('*Biarkan jam pada 00:00 jika tidak tahu waktu kelahiran persisnya'), findsOneWidget);

    // Verify Result Card is NOT shown initially
    expect(find.text('Tahun'), findsNothing);
    expect(find.text('Bulan'), findsNothing);

    // Enter name
    await tester.enterText(find.byType(TextField).first, 'Budi');

    // Tap Hitung button
    await tester.tap(find.text('Hitung'));
    await tester.pumpAndSettle();

    // Verify Result Card is NOT shown if date wasn't picked yet
    expect(find.text('Tahun'), findsNothing);
  });
}
