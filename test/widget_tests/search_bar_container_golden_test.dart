import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/widgets/search_bar_container.dart';
import 'utils/golden_helper.dart';

void main() {
  testGoldens('SearchBarContainer – empty', (tester) async {
    final ctrl = TextEditingController();
    await goldenPerf(
      tester,
      SearchBarContainer(search: ctrl),
      'search_bar_container_empty',
      surfaceSize: const Size(360, 60),
    );
  });

  testGoldens('SearchBarContainer – with text', (tester) async {
    final ctrl = TextEditingController(text: 'flutter');
    await goldenPerf(
      tester,
      SearchBarContainer(search: ctrl),
      'search_bar_container_with_text',
      surfaceSize: const Size(360, 60),
    );
  });
}
