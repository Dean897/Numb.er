import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terminal_math_team_utility/pages/journal_page.dart';

void main() {
  testWidgets('JournalPage displays list of respondents and supports CRUD actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: JournalPage(),
      ),
    );

    // Verify Title Header
    expect(find.text('Buku Jurnal Digital'), findsWidgets);

    // Verify Top Action Button
    expect(find.text('Tambah Responden Baru'), findsOneWidget);

    // Verify Summary Bar
    expect(find.text('Log Wawancara Terbaru'), findsOneWidget);
    expect(find.text('4 Data'), findsOneWidget);

    // Verify Initial Sample Items
    expect(find.text('Bapak Prabowo'), findsOneWidget);
    expect(find.text('Balai Desa'), findsOneWidget);

    // Tap "Tambah Responden Baru" button to open form
    await tester.tap(find.text('Tambah Responden Baru'));
    await tester.pumpAndSettle();

    // Verify Form Card labels
    expect(find.text('Nama Responden'), findsOneWidget);
    expect(find.text('Lokasi Wawancara'), findsOneWidget);
    expect(find.text('Catatan Wawancara'), findsOneWidget);

    // Fill form
    await tester.enterText(find.byKey(const Key('nameField')), 'Ibu Megawati');
    await tester.enterText(find.widgetWithText(TextField, 'Masukkan lokasi wawancara'), 'Jakarta');
    await tester.enterText(find.widgetWithText(TextField, 'Tulis ringkasan catatan wawancara...'), 'Diskusi politik');
    await tester.pumpAndSettle();

    // Drag up to tap Simpan
    await tester.drag(find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Reset scroll to top
    tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);
    await tester.pumpAndSettle();

    expect(find.text('5 Data'), findsOneWidget);

    // Scroll until Ibu Megawati is visible
    await tester.scrollUntilVisible(find.text('Ibu Megawati'), 100);
    expect(find.text('Ibu Megawati'), findsOneWidget);

    // Reset scroll to top for edit
    tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);
    await tester.pumpAndSettle();

    // Edit item
    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Edit Data Responden'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('nameField')), 'Bapak Prabowo Subianto');
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);
    await tester.pumpAndSettle();

    expect(find.text('Bapak Prabowo Subianto'), findsOneWidget);

    // Delete item
    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    expect(find.text('Hapus Data Responden?'), findsOneWidget);
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(find.text('4 Data'), findsOneWidget);
  });
}
