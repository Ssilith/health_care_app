@JS()
library mem_web;

import 'dart:html' as html;
import 'dart:js_interop';
import 'package:js/js_util.dart' as jsu;

int getCurrentMemory() {
  try {
    final mem = jsu.getProperty(html.window.performance, 'memory');
    return jsu.getProperty<int>(mem, 'usedJSHeapSize');
  } catch (_) {
    return -1;
  }
}
