import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/chat/chat_bubble.dart';

import 'utils/golden_helper.dart';

void main() {
  testGoldens('ChatBubble - current vs remote user', (tester) async {
    await goldenPerf(
      tester,
      Column(
        children: const [
          ChatBubble(message: 'Hi!', isCurrentUser: true),
          ChatBubble(message: 'Hello', isCurrentUser: false),
        ],
      ),
      'chat_bubble_default',
      surfaceSize: const Size(220, 140),
    );
  });
}
