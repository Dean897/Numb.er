import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terminal_math_team_utility/pages/digit_sum_page.dart';

void main() {
  testWidgets('menjumlahkan setiap digit yang berdempetan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DigitSumPage()));

    await tester.enterText(find.byType(TextField), '854');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Jumlahkan'));
    await tester.pump();

    expect(find.text('8 + 5 + 4'), findsOneWidget);
    expect(find.text('17'), findsOneWidget);
  });

  testWidgets('mengambil angka dari dalam kalimat', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DigitSumPage()));

    await tester.enterText(find.byType(TextField), 'Nilai 854 pada baris 2');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Jumlahkan'));
    await tester.pump();

    expect(find.text('8 + 5 + 4 + 2'), findsOneWidget);
    expect(find.text('19'), findsOneWidget);
  });
}
