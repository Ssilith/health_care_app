// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js' as js;

int getRssKb() {
  try {
    final perf = window.performance as dynamic;
    if (perf.memory == null || perf.memory.usedJSHeapSize == null) {
      return -1;
    }

    try {
      js.context.callMethod('gc');
    } catch (_) {}

    return ((perf.memory.usedJSHeapSize as num) ~/ 1024);
  } catch (e) {
    return -1;
  }
}
