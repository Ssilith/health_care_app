import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/blank_scaffold.dart';

import 'utils/golden_helper.dart';

void main() {
  testGoldens('BlankScaffold default', (tester) async {
    await goldenPerf(
      tester,
      BlankScaffold(body: Center(child: Text('Hello World'))),
      'blank_scaffold_default',
      surfaceSize: const Size(360, 640),
    );
  });
}
