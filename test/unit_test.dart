import 'package:flutter_test/flutter_test.dart';

import 'unit/auth_service_test.dart' as auth_tests;
import 'unit/chat_service_test.dart' as chat_tests;
import 'unit/chat_service_error_test.dart' as chat_err_tests;
import 'unit/geo_service_test.dart' as geo_tests;
import 'unit/geo_service_empty_test.dart' as geo_empty_tests;
import 'unit/insert_pdf_service_test.dart' as insert_pdf_tests;
import 'unit/appointment_service_test.dart' as appointment_tests;
import 'unit/ice_service_test.dart' as ice_tests;
import 'unit/notebook_service_test.dart' as notebook_tests;
import 'utils/benchmark_helper.dart';

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
