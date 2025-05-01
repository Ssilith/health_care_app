import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/main_switch.dart';
import 'package:flutter/material.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('MainSwitch toggles value and calls callback', (tester) async {
    var state = true;

    await tester.pumpWidget(
      MaterialApp(
        home: MainSwitch(
          current: state,
          firstTitle: 'LIST',
          secondTitle: 'CAL',
          firstIconData: Icons.list,
          secondIconData: Icons.calendar_month,
          onChanged: (b) => state = b,
        ),
      ),
    );

    await runPerf(() async {
      await tester.tap(find.byType(AnimatedToggleSwitch<bool>));
      await tester.pumpAndSettle();
      expect(state, isFalse);
    }, name: 'widget_main_switch_toggle');
  });
}
