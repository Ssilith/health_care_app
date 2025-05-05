import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'widget_tests/chat_bubble_golden_test.dart' as chat_bubble_gold;
import 'widget_tests/action_container_golden_test.dart' as action_gold;
import 'widget_tests/text_input_form_golden_test.dart' as input_gold;
import 'widget_tests/search_bar_container_golden_test.dart' as search_gold;
import 'widget_tests/rectangular_button_golden_test.dart' as rect_gold;
import 'widget_tests/popup_window_golden_test.dart' as popup_gold;
import 'widget_tests/main_switch_golden_test.dart' as switch_gold;
import 'widget_tests/blank_scaffold_golden_test.dart' as scaffold_gold;
import 'widget_tests/appointment_container_golden_test.dart' as appt_gold;

import 'utils/benchmark_helper.dart';
import 'utils/firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    await setupFirebaseForTests();
    await loadAppFonts();
    if (kIsWeb) {
      goldenFileComparator = webGoldenComparator as GoldenFileComparator;
    }
  });

  group('All Golden Tests', () {
    chat_bubble_gold.main();
    action_gold.main();
    input_gold.main();
    search_gold.main();
    rect_gold.main();
    popup_gold.main();
    switch_gold.main();
    scaffold_gold.main();
    appt_gold.main();
  });

  tearDownAll(dumpPerfReports);
}
