// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html';

int getRssKb() {
  try {
    final mem = (window.performance as dynamic).memory;
    return ((mem.usedJSHeapSize as num) ~/ 1024);
  } catch (_) {
    return -1;
  }
}
