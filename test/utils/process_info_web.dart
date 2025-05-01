// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:js' as js;

int getRssKb() {
  try {
    final performance = window.performance;
    final memory = js.JsObject.fromBrowserObject(performance)['memory'];

    if (memory != null) {
      try {
        js.context.callMethod('gc');
      } catch (_) {}

      Future.delayed(const Duration(milliseconds: 100));

      final usedHeapSize = memory['usedJSHeapSize'];
      if (usedHeapSize != null) {
        return (usedHeapSize as num) ~/ 1024;
      }
    }

    try {
      final navigator = js.JsObject.fromBrowserObject(window.navigator);
      final deviceMemory = navigator['deviceMemory'];
      if (deviceMemory != null) {
        return ((deviceMemory as num) * 1024).toInt();
      }
    } catch (_) {}

    return -1;
  } catch (e) {
    return -1;
  }
}
