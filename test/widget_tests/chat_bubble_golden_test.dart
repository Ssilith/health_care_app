import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/chat/chat_bubble.dart';

final String goldenPlatform = const String.fromEnvironment(
  'GOLDEN_PLATFORM',
  defaultValue: 'mobile',
);
final bool isWeb = goldenPlatform == 'web';

void main() {
  group('ChatBubble Golden Tests', () {
    testGoldens('ChatBubble renders correctly', (tester) async {
      final goldenFileName = 'chat_bubble_${isWeb ? 'web' : 'mobile'}';

      await tester.pumpWidgetBuilder(
        Material(
          child: ChatBubble(message: 'Hello, world!', isCurrentUser: true),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
      );

      await screenMatchesGolden(tester, goldenFileName);
    });
  });
}
