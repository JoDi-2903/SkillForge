// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_forge/main.dart';

void main() {
  testWidgets('Initial app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify basic app structure
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(MyHomePage), findsOneWidget);

    // Test navigation bar presence
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Test calendar presence
    expect(find.byType(GridView), findsOneWidget);

    // Test app bar buttons
    expect(find.byType(LoginButton), findsOneWidget);
    expect(find.byType(CalendarButton), findsOneWidget);
    expect(find.byType(ToggleSwitch), findsOneWidget);
  });
}
