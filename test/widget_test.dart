import 'package:flutter_test/flutter_test.dart';

import 'widget_tests/appointment_container_smoke_test.dart' as appt_smoke;
import 'widget_tests/notebook_form_validation_test.dart' as notebook_val;
import 'widget_tests/action_container_tap_test.dart' as action_tap;
import 'widget_tests/main_switch_toggle_test.dart' as switch_toggle;
import 'widget_tests/blank_scaffold_smoke_test.dart' as blank_scaffold;
import 'widget_tests/chat_bubble_test.dart' as chat_bubble;
import 'widget_tests/text_input_form_toggle_test.dart' as text_toggle;
import 'widget_tests/rectangular_button_disabled_test.dart' as rect_btn;
import 'widget_tests/popup_window_buttons_test.dart' as popup_btn;
import 'widget_tests/search_bar_filter_test.dart' as search_bar;
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
  setUpAll(() async => await setupFirebaseForTests());

  group('All Widget Tests', () {
    appt_smoke.main();
    notebook_val.main();
    action_tap.main();
    switch_toggle.main();
    blank_scaffold.main();
    chat_bubble.main();
    text_toggle.main();
    rect_btn.main();
    popup_btn.main();
    search_bar.main();
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
