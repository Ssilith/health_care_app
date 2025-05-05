import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/appointments/main_switch.dart';

import 'utils/golden_helper.dart';

void main() {
  testGoldens('MainSwitch – default', (tester) async {
    await goldenPerf(
      tester,
      MainSwitch(
        current: true,
        firstTitle: 'LIST',
        secondTitle: 'CAL',
        firstIconData: Icons.list,
        secondIconData: Icons.calendar_month,
        onChanged: (_) {},
      ),
      'main_switch_default',
      surfaceSize: const Size(200, 60),
    );
  });
}
