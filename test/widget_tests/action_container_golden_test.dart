import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/widgets/action_container.dart';

import 'utils/golden_helper.dart';

void main() {
  testGoldens('ActionContainer - idle state', (tester) async {
    await goldenPerf(
      tester,
      ActionContainer(title: 'Chat bot', iconData: Icons.chat, onTap: () {}),
      'action_container_default',
      surfaceSize: const Size(300, 350),
    );
  });
}
