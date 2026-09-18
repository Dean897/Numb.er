// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_math_team_utility/main.dart';

void main() {
  testWidgets('login menampilkan menu utama', (WidgetTester tester) async {
    await tester.pumpWidget(const KalaRisetApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), '12345');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Buku jurnal digital'), findsOneWidget);
    expect(find.text('Hitung'), findsOneWidget);
  });
}
