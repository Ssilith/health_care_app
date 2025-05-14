// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter, deprecated_member_use

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

Future<void> callNativeGC() async {
  try {
    if (jsu.hasProperty(html.window, 'gc')) {
      jsu.callMethod(html.window, 'gc', []);
    } else {
      var arr = [];
      for (var i = 0; i < 10; i++) {
        arr.add(List.filled(1000000, 0));
        await Future.delayed(const Duration(milliseconds: 10));
        arr = [];
      }
    }
  } catch (_) {}
}
