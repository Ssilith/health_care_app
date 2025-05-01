import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import 'process_info_web.dart' if (dart.library.io) 'process_info_io.dart';

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

  for (int i = 0; i < repeat; i++) {
    final sw = Stopwatch()..start();
    try {
      await action();
    } catch (_) {
      failures++;
    } finally {
      sw.stop();
      timings.add(sw.elapsedMicroseconds);
    }
  }

  timings.sort();
  final avg = timings.reduce((a, b) => a + b) / repeat;
  final p95 = _percentile(timings, .95);
  final stdev = math.sqrt(
    timings.map((t) => math.pow(t - avg, 2)).reduce((a, b) => a + b) / repeat,
  );

  final report = {
    'test': name,
    'repeat': repeat,
    'avg_us': avg,
    'p95_us': p95,
    'stdev_us': stdev,
    'failures': failures,
    'platform': kIsWeb ? 'web' : 'mobile',
  };

  if (kIsWeb) {
    report['js_allocation_time_ms'] = await customMemoryBenchmark();
  } else {
    report['rss_kb'] = getRssKb();
  }

  globalPerfReports.add(report);
}

void dumpPerfReports() {
  print('PERF_REPORT_START');
  print(jsonEncode(globalPerfReports));
  print('PERF_REPORT_END');
}

Future<int> customMemoryBenchmark() async {
  final start = DateTime.now().millisecondsSinceEpoch;

  final list = <List<int>>[];
  for (int i = 0; i < 100; i++) {
    list.add(List.filled(10000, i));
    await Future.delayed(Duration.zero);
  }

  final end = DateTime.now().millisecondsSinceEpoch;
  return end - start;
}
