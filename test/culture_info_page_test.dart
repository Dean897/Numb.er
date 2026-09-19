import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terminal_math_team_utility/pages/culture_info_page.dart';

void main() {
  testWidgets(
    'CultureInfoPage displays background image, top title, mode switcher and conversion cards',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CultureInfoPage()));

      // Verify Title Header
      expect(find.text('Konversi Kalender'), findsWidgets);

      // Verify Mode Switcher
      expect(find.text('Masehi   Historis'), findsOneWidget);
      expect(find.text('Historis   Masehi'), findsOneWidget);

      // Verify Default Mode 0 Form Elements
      expect(find.text('Tanggal Masehi'), findsOneWidget);
      expect(find.text('Tujuan Konversi'), findsOneWidget);
      expect(find.text('Hijriah'), findsWidgets);
      expect(find.text('Weton'), findsWidgets);
      expect(find.text('Saka Bali'), findsWidgets);

      // Verify Result Card is NOT shown initially
      expect(find.text('Hasil Konversi'), findsNothing);

      // Verify Conversion Button
      expect(find.text('Konversi Penanggalan'), findsOneWidget);

      // Tap Konversi Penanggalan
      await tester.tap(find.text('Konversi Penanggalan'));
      await tester.pumpAndSettle();

      // Verify Result Card Header & Content is shown after conversion
      expect(find.text('Hasil Konversi'), findsOneWidget);
      expect(find.text('Masehi'), findsOneWidget);
      expect(find.textContaining('September 2026 M'), findsOneWidget);

      // Switch to Mode 1 (Historis -> Masehi)
      await tester.tap(find.text('Historis   Masehi'));
      await tester.pumpAndSettle();

      expect(find.text('Tanggal'), findsOneWidget);
      expect(find.text('Bulan'), findsOneWidget);
      expect(find.text('Tahun Hijriah (H)'), findsOneWidget);

      // Tap Konversi Penanggalan
      await tester.tap(find.text('Konversi Penanggalan'));
      await tester.pumpAndSettle();

      expect(find.text('Hasil Konversi'), findsOneWidget);
    },
  );

  testWidgets('Weton Historis memakai bulan Jawa dan tahun Jawa', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CultureInfoPage()));

    await tester.tap(find.text('Historis   Masehi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weton'));
    await tester.pumpAndSettle();

    expect(find.text('Sura'), findsOneWidget);
    expect(find.text('Tahun Weton'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Weton Jawa'), findsOneWidget);
    expect(find.textContaining('1959 Jawa'), findsOneWidget);
  });
}
