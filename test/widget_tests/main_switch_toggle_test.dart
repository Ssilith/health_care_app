import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/main_switch.dart';
import 'package:flutter/material.dart';
import '../utils/benchmark_helper.dart';
import 'utils/pump_widget.dart';

void main() {
  testWidgets('MainSwitch toggles value and calls callback', (tester) async {
    var state = true;

    final switchKey = GlobalKey<MainSwitchState>();

    await pumpWithMaterial(
      tester,
      MainSwitch(
        key: switchKey,
        current: state,
        firstTitle: 'LIST',
        secondTitle: 'CAL',
        firstIconData: Icons.list,
        secondIconData: Icons.calendar_month,
        onChanged: (b) => state = b,
      ),
    );

    await tester.pumpAndSettle();

    await runPerf(() async {
      switchKey.currentState?.setState(() {
        switchKey.currentState?.current = false;
      });
      await tester.pumpAndSettle();

      switchKey.currentState?.widget.onChanged(false);
      await tester.pumpAndSettle();

      expect(state, isFalse);
    }, name: 'widget_main_switch_toggle');
  });
}
