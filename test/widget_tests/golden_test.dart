import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// Import all your golden test files
import 'chat_bubble_golden_test.dart' as chat_bubble_gold;
import 'action_container_golden_test.dart' as action_gold;
import 'text_input_form_golden_test.dart' as input_gold;
import 'search_bar_container_golden_test.dart' as search_gold;
import 'rectangular_button_golden_test.dart' as rect_gold;
import 'popup_window_golden_test.dart' as popup_gold;
import 'main_switch_golden_test.dart' as switch_gold;
import 'blank_scaffold_golden_test.dart' as scaffold_gold;
import 'appointment_container_golden_test.dart' as appt_gold;

import '../utils/benchmark_helper.dart';
import '../utils/firebase_test_setup.dart';

// Platform detection
final String goldenPlatform = const String.fromEnvironment(
  'GOLDEN_PLATFORM',
  defaultValue: 'mobile',
);
final bool isWeb = goldenPlatform == 'web' || kIsWeb;

// Get tolerance from environment variables or use defaults
final double tolerance =
    double.tryParse(
      const String.fromEnvironment('TOLERANCE', defaultValue: '0.01'),
    ) ??
    (isWeb ? 0.05 : 0.01);

void main() async {
  await loadAppFonts();
  await setupFirebaseForTests();

  // Configure golden toolkit
  GoldenToolkitConfiguration(
    defaultDevices: [Device.phone, Device.tabletPortrait],
  );

  // Set up platform-specific golden comparators
  if (isWeb) {
    goldenFileComparator = webGoldenComparator as GoldenFileComparator;
  } else {
    // For mobile platform, set up custom directory for failures if needed
    if (!kIsWeb) {
      final failDirectory = Directory('test/failures');
      if (!failDirectory.existsSync()) {
        failDirectory.createSync(recursive: true);
      }
    }
  }

  // Set the text scale factor
  TestWidgetsFlutterBinding.ensureInitialized();

  // Now we can declare groups and tests
  group('Golden Tests ($goldenPlatform)', () {
    chat_bubble_gold.main();
    // action_gold.main();
    // input_gold.main();
    // search_gold.main();
    // rect_gold.main();
    // popup_gold.main();
    // switch_gold.main();
    // scaffold_gold.main();
    // appt_gold.main();
  });

  // Register teardown
  tearDownAll(() {
    dumpPerfReports();
  });
}
