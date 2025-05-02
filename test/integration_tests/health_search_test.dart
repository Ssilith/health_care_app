import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/global.dart';
import 'package:health_care_app/main.dart';
import 'package:health_care_app/widgets/search_bar_container.dart';

import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('health_search', (tester) async {
    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.pumpAndSettle();

      for (var action in homePageActions) {
        expect(find.text(action.keys.first), findsOneWidget);
      }

      await tester.enterText(
        find.byType(SearchBarContainer).first,
        'emergency',
      );
      await tester.pump();

      expect(find.text('In case of emergency'), findsOneWidget);
      expect(find.text('Med notebook'), findsNothing);
      expect(find.text('Appointments'), findsNothing);

      await tester.enterText(find.byType(SearchBarContainer).first, '');
      await tester.pump();

      for (var action in homePageActions) {
        expect(find.text(action.keys.first), findsOneWidget);
      }
    }, name: 'health_search');
  });
}
