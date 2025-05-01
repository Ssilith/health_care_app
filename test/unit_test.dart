import 'package:flutter_test/flutter_test.dart';

import 'unit_tests/unit/auth_service_test.dart' as auth_tests;
import 'unit_tests/unit/chat_service_test.dart' as chat_tests;
import 'unit_tests/unit/chat_service_error_test.dart' as chat_err_tests;
import 'unit_tests/unit/geo_service_test.dart' as geo_tests;
import 'unit_tests/unit/geo_service_empty_test.dart' as geo_empty_tests;
import 'unit_tests/unit/insert_pdf_service_test.dart' as insert_pdf_tests;
import 'unit_tests/unit/appointment_service_test.dart' as appointment_tests;
import 'unit_tests/unit/ice_service_test.dart' as ice_tests;
import 'unit_tests/unit/notebook_service_test.dart' as notebook_tests;
import 'unit_tests/utils/benchmark_helper.dart';

void main() {
  group('All Unit Tests', () {
    auth_tests.main();
    chat_tests.main();
    chat_err_tests.main();
    geo_tests.main();
    geo_empty_tests.main();
    insert_pdf_tests.main();
    appointment_tests.main();
    ice_tests.main();
    notebook_tests.main();
  });

  tearDownAll(() {
    dumpPerfReports();
  });
}
