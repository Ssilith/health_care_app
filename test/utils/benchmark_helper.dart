// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

const int _defaultRepeat = int.fromEnvironment(
  'BENCHMARK_REPEAT',
  defaultValue: 100,
);

final _reports = <Map<String, dynamic>>[];

double _pct(List<int> data, double p) =>
    data[(p * (data.length - 1)).round()].toDouble();

Future<void> runPerf(
  Future<void> Function() action, {
  String name = 'unnamed',
  int repeat = _defaultRepeat,
  Future<void> Function()? warmUp,
  Map<String, Object?> extras = const {},
}) async {
  final timings = <int>[];
  int failures = 0;

  if (warmUp != null) await warmUp();

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

  if (timings.isEmpty) timings.add(0);

  timings.sort();
  final avg = timings.reduce((a, b) => a + b) / repeat;
  final p95 = _pct(timings, .95);
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
    ...extras,
  };

  _reports.add(report);
}

void dumpPerfReports() {
  print('PERF_REPORT_START');
  print(jsonEncode(_reports));
  print('PERF_REPORT_END');
}
