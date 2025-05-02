import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/main_switch.dart';

import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('main_switch_toggle_perf', (tester) async {
    bool state = true;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainSwitch(
            current: state,
            firstTitle: 'A',
            secondTitle: 'B',
            firstIconData: Icons.close,
            secondIconData: Icons.check,
            onChanged: (b) => state = b,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await runPerf(() async {
      for (int i = 0; i < 50; i++) {
        await tester.tap(find.byKey(const Key('mainSwitch')));
        await tester.pump();
      }
      expect(state, isFalse);
    }, name: 'main_switch_toggle_50');
  });
}
