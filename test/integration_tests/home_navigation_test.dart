import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/main.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('home_navigation', (tester) async {
    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'chat');
      await tester.pumpAndSettle();
      expect(find.text('Chat bot'), findsOneWidget);

      await tester.tap(find.text('Chat bot'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('backButton')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(find.text('Appointments'), findsOneWidget);
    }, name: 'home_navigation');
  });
}
