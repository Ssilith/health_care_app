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
