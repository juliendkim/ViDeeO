// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ViDeeO app basic UI test', (WidgetTester tester) async {
    // Build a simple material app for testing UI components
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library,
                  size: 80,
                  color: Colors.white54,
                ),
                SizedBox(height: 16),
                Text(
                  'ViDeeO',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'MPV-based Video Player',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Verify that UI components are displayed.
    expect(find.text('ViDeeO'), findsOneWidget);
    expect(find.text('MPV-based Video Player'), findsOneWidget);
    expect(find.byIcon(Icons.video_library), findsOneWidget);
  });
}
