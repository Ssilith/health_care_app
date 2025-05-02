// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

const int _defaultRepeat = int.fromEnvironment(
  'BENCHMARK_REPEAT',
  defaultValue: 100,
);

final List<Map<String, dynamic>> globalPerfReports = [];

double _percentile(List<int> sorted, double p) =>
    sorted[(p * (sorted.length - 1)).round()].toDouble();

Future<void> runPerf(
  Future<void> Function() action, {
  String name = 'unnamed',
  int repeat = _defaultRepeat,
}) async {
  final timings = <int>[];
  int failures = 0;

  await action();

  for (int i = 0; i < repeat; i++) {
    final sw = Stopwatch();
    bool failed = false;
    try {
      sw.start();
      await action();
    } catch (_) {
      failures++;
      failed = true;
    } finally {
      sw.stop();
      if (!failed) timings.add(sw.elapsedMicroseconds);
    }
  }

  timings.sort();
  final avg = timings.reduce((a, b) => a + b) / repeat;
  final p95 = _percentile(timings, .95);
  final stdev = math.sqrt(
    timings.map((t) => math.pow(t - avg, 2)).reduce((a, b) => a + b) / repeat,
  );

  final report = <String, dynamic>{
    'test': name,
    'repeat': repeat,
    'avg_us': avg,
    'p95_us': p95,
    'stdev_us': stdev,
    'failures': failures,
    'platform': kIsWeb ? 'web' : 'mobile',
  };

  globalPerfReports.add(report);
}

void dumpPerfReports() {
  print('PERF_REPORT_START');
  print(jsonEncode(globalPerfReports));
  print('PERF_REPORT_END');
}
