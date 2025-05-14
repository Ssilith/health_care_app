import 'dart:io' as io;

int getCurrentMemory() => io.ProcessInfo.currentRss;

Future<void> callNativeGC() async {
  try {
    for (var i = 0; i < 5; i++) {
      List<int> tmp = List.filled(1000000, 0);
      tmp.clear();
      await Future.delayed(const Duration(milliseconds: 20));
    }

    if (io.Platform.isAndroid) {
      try {
        await io.Process.run('runtime', ['gc']);
      } catch (_) {}
    }
  } catch (_) {}
}
