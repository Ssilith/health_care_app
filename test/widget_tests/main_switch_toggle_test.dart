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

    await tester.pumpAndSettle();

    await runPerf(() async {
      final switchRect = tester.getRect(find.byKey(const Key('mainSwitch')));

      final tapPoint = Offset(
        switchRect.left + switchRect.width * 0.25,
        switchRect.center.dy,
      );

      await tester.tapAt(tapPoint);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(state, isFalse);
    }, name: 'widget_main_switch_toggle');
  });
}
