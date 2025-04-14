import 'package:flutter_test/flutter_test.dart';

import 'services/auth_service_test.dart' as auth_tests;
import 'services/chat_service_test.dart' as chat_tests;
import 'services/geo_service_test.dart' as geo_tests;
import 'services/insert_pdf_service_test.dart' as insert_pdf_tests;
import 'services/appointment_service_test.dart' as appointment_test;
import 'services/ice_service_test.dart' as ice_tests;
import 'services/notebook_service_test.dart' as notebook_tests;
import 'utils/benchmark_helper.dart';

void main() {
  group('All Unit Tests', () {
    auth_tests.main();
    chat_tests.main();
    geo_tests.main();
    insert_pdf_tests.main();
    appointment_test.main();
    ice_tests.main();
    notebook_tests.main();
  });

  tearDownAll(() {
    outputBenchmarkReport(globalBenchmarkReports);
  });
}
