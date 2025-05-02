import 'package:flutter_test/flutter_test.dart';

import 'integration_tests/auth_flow_test.dart' as auth;
import 'integration_tests/home_navigation_test.dart' as home;
import 'integration_tests/appointment_flow_test.dart' as appt;
import 'integration_tests/notebook_flow_test.dart' as notebook;
import 'integration_tests/ice_info_flow_test.dart' as ice;
import 'integration_tests/chat_user_message_test.dart' as chat;
import 'integration_tests/search_filter_perf_test.dart' as search;
import 'integration_tests/theme_toggle_test.dart' as theme;
import 'utils/benchmark_helper.dart';
import 'utils/firebase_test_setup.dart';

void main() {
  setUpAll(() async => await setupFirebaseForTests());

  group('All Integration Tests', () {
    auth.main();
    home.main();
    appt.main();
    notebook.main();
    ice.main();
    chat.main();
    search.main();
    theme.main();
  });

  tearDownAll(dumpPerfReports);
}
