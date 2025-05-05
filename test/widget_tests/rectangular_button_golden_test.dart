import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'utils/golden_helper.dart';

void main() {
  testGoldens('RectangularButton – normal', (tester) async {
    await goldenPerf(
      tester,
      RectangularButton(title: 'Click me', isLoading: false, onPressed: () {}),
      'rectangular_button_normal',
      surfaceSize: const Size(200, 50),
    );
  });

  testGoldens('RectangularButton – loading', (tester) async {
    await goldenPerf(
      tester,
      RectangularButton(title: 'Click me', isLoading: true, onPressed: () {}),
      'rectangular_button_loading',
      surfaceSize: const Size(200, 50),
    );
  });
}
