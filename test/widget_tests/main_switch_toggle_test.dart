import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/appointments/main_switch.dart';
import 'package:flutter/material.dart';
import '../utils/benchmark_helper.dart';
import 'utils/pump_widget.dart';

void main() {
  testWidgets('MainSwitch toggles value and calls callback', (tester) async {
    var state = true;

    await pumpWithMaterial(
      tester,
      MainSwitch(
        current: state,
        firstTitle: 'LIST',
        secondTitle: 'CAL',
        firstIconData: Icons.list,
        secondIconData: Icons.calendar_month,
        onChanged: (b) => state = b,
      ),
    );

    await tester.tap(find.byKey(const Key('mainSwitch')));
    await tester.pump(const Duration(milliseconds: 350));
    expect(state, isFalse);

    await runPerf(() async {
      await tester.tap(find.byKey(const Key('mainSwitch')));
      await tester.pump(const Duration(milliseconds: 350));
    }, name: 'widget_main_switch_toggle');
  });
}
