import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/global.dart';
import 'package:health_care_app/main.dart';

import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('search_filter_latency_1k', (tester) async {
    await runPerf(
      () async {
        for (var i = 0; i < 1000; i++) {
          homePageActions.add({'item $i': Icons.widgets});
        }

        await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'item 900');
        await tester.pumpAndSettle();

        expect(find.text('item 900'), findsWidgets);
      },
      name: 'search_filter_latency_1k',
      repeat: 20,
    );
  });
}
