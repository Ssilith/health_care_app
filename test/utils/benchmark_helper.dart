// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'memory/mem_stub.dart'
    if (dart.library.io) 'memory/mem_io.dart'
    if (dart.library.html) 'memory/mem_web.dart';

const int _defaultRepeat = int.fromEnvironment(
  'BENCHMARK_REPEAT',
  defaultValue: 10,
);

final _reports = <Map<String, dynamic>>[];

Future<void> forceGarbageCollection() async {
  var list = <List<int>>[];
  try {
    for (var i = 0; i < 10; i++) {
      list.add(List<int>.filled(1000000, 0));
      await Future.delayed(const Duration(milliseconds: 50));
    }
  } catch (_) {}

  list.clear();

  await callNativeGC();

  await Future.delayed(const Duration(milliseconds: 200));
}

// Modified runPerf function that includes garbage collection
Future<void> runPerf(
  Future<void> Function() action, {
  String name = 'unnamed',
  int repeat = _defaultRepeat,
  bool forceGC = true, // New parameter
}) async {
  final timings = <int>[];
  int failures = 0;

  // Force GC before starting tests if requested
  if (forceGC) {
    print('[$name] Forcing garbage collection before test...');
    await forceGarbageCollection();
  }

  final rssBefore = getCurrentMemory();

  for (var i = 0; i < repeat; i++) {
    // Optionally force GC between test iterations
    if (forceGC && i > 0) {
      print('[$name] Forcing garbage collection between iterations...');
      await forceGarbageCollection();
    }

    final sw = Stopwatch()..start();
    var failed = false;
    try {
      await action();
    } catch (e) {
      print('[$name] Test iteration $i failed: $e');
      failures++;
      failed = true;
    } finally {
      sw.stop();
      if (!failed) timings.add(sw.elapsedMicroseconds);
    }
  }

  // Force GC after completing tests if requested
  if (forceGC) {
    print('[$name] Forcing garbage collection after test...');
    await forceGarbageCollection();
  }

  final rssAfter = getCurrentMemory();

  if (timings.isEmpty) timings.add(0);
  timings.sort();

  double pct(List<int> d, double p) =>
      d[(p * (d.length - 1)).round()].toDouble();

  final avg = timings.reduce((a, b) => a + b) / timings.length;
  final p50 = pct(timings, .50);
  final p95 = pct(timings, .95);
  final min = timings.first.toDouble();
  final max = timings.last.toDouble();
  final stdev = math.sqrt(
    timings.fold<double>(0, (s, v) => s + math.pow(v - avg, 2)) /
        timings.length,
  );
  final cov = avg != 0.0 && !avg.isNaN ? (stdev / avg) : 0.0;

  _reports.add({
    'test': name,
    'repeat': repeat,
    'avg_us': avg,
    'p50_us': p50,
    'p95_us': p95,
    'min_us': min,
    'max_us': max,
    'stdev_us': stdev,
    'cov': cov,
    'failures': failures,
    'flaky': failures / repeat > 0.02,
    'platform': kIsWeb ? 'web' : 'mobile',
    'rss_before_kb': rssBefore == -1 ? null : rssBefore ~/ 1024,
    'rss_after_kb': rssAfter == -1 ? null : rssAfter ~/ 1024,
    'rss_delta_kb':
        (rssBefore == -1 || rssAfter == -1)
            ? null
            : (rssAfter - rssBefore) ~/ 1024,
    'gc_forced': forceGC,
  });
}

void dumpPerfReports() {
  print('PERF_REPORT_START');
  print(jsonEncode(_reports));
  print('PERF_REPORT_END');
}
