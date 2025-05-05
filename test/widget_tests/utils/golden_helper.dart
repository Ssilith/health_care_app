import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../utils/benchmark_helper.dart';

Future<void> goldenPerf(
  WidgetTester tester,
  Widget widget,
  String name, {
  Size surfaceSize = const Size(300, 150),
}) async {
  await runPerf(
    () async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(widget, surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, name);
    },
    name: 'golden_$name',
    repeat: 1,
  );
}
