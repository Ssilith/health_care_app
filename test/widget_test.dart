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
import 'widget_tests/navigate_to_copy_test.dart' as copy_test;
import 'widget_tests/search_bar_filter_test.dart' as search_bar;

import 'utils/benchmark_helper.dart';

void main() {
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
    copy_test.main();
    search_bar.main();
  });

  tearDownAll(dumpPerfReports);
}
