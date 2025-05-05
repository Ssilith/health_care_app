import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import 'utils/golden_helper.dart';

void main() {
  testGoldens('PopupWindow – default', (tester) async {
    await goldenPerf(
      tester,
      PopupWindow(title: 'Confirm', message: 'Are you sure?', onPressed: () {}),
      'popup_window_default',
      surfaceSize: const Size(300, 200),
    );
  });
}
