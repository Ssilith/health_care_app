import 'dart:convert';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';

const int benchmarkRepeat = int.fromEnvironment(
  'BENCHMARK_REPEAT',
  defaultValue: 100,
);

final List<Map<String, dynamic>> globalBenchmarkReports = [];

Future<Map<String, dynamic>> runBenchmark(
  Future<void> Function() action, {
  int iterations = benchmarkRepeat,
  required String testName,
}) async {
  final List<int> timings = [];
  for (int i = 0; i < iterations; i++) {
    final stopwatch = Stopwatch()..start();
    await action();
    stopwatch.stop();
    timings.add(stopwatch.elapsedMilliseconds);
  }
  final totalMs = timings.fold(0, (int sum, int t) => sum + t);
  final avgMs = totalMs / iterations;
  final report = {
    'test': testName,
    'iterations': iterations,
    'totalMilliseconds': totalMs,
    'averageMilliseconds': avgMs,
    'timings': timings,
  };

  globalBenchmarkReports.add(report);

  return report;
}

Future<void> writeBenchmarkReport() async {
  final jsonString = jsonEncode(globalBenchmarkReports);
  final fileName =
      'all_benchmarks_${DateTime.now().millisecondsSinceEpoch}.json';

  if (kIsWeb) {
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'files', fileName);
    final file = io.File(filePath);
    await file.create(recursive: true);
    await file.writeAsString(jsonString, flush: true);
  }
}
