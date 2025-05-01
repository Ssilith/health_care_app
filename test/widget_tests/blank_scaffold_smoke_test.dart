import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/blank_scaffold.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('BlankScaffold shows leading button and pops', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: BlankScaffold(body: const SizedBox.shrink())),
    );

    await runPerf(() async {
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
    }, name: 'widget_blank_scaffold_pop');
  });
}
