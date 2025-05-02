import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/blank_scaffold.dart';
import '../utils/benchmark_helper.dart';
import 'utils/pump_widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('BlankScaffold shows leading button and pops', (tester) async {
    await pumpWithMaterial(
      tester,
      const BlankScaffold(body: SizedBox.shrink()),
    );

    await runPerf(() async {
      final back = find.byKey(const Key('backButton'));
      // await tester.ensureVisible(back);
      expect(find.byType(BlankScaffold), findsOneWidget);
      await tester.tap(back);
      await tester.pumpAndSettle();
      // expect(back, findsOneWidget);
      expect(find.byType(BlankScaffold), findsNothing);
    }, name: 'widget_blank_scaffold_pop');
  });
}
