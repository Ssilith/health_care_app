import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/chat/chat_bubble.dart';

final String goldenPlatform = const String.fromEnvironment(
  'GOLDEN_PLATFORM',
  defaultValue: 'mobile',
);
final bool isWebPlatform = goldenPlatform == 'web';

void main() {
  group('ChatBubble Golden Tests', () {
    testGoldens('ChatBubble renders correctly', (tester) async {
      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(
              devices: [Device.phone, Device.tabletPortrait],
            )
            ..addScenario(
              widget: Material(
                child: ChatBubble(
                  message: 'Hello, world!',
                  isCurrentUser: true,
                ),
              ),
              name: 'chat_bubble_mine',
            )
            ..addScenario(
              widget: Material(
                child: ChatBubble(message: 'Hi there!', isCurrentUser: false),
              ),
              name: 'chat_bubble_other',
            );

      // Platform-specific golden file name
      final goldenFileName =
          'chat_bubble_${isWebPlatform ? 'web' : 'mobile'}.png';

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, goldenFileName);
    });
  });
}
