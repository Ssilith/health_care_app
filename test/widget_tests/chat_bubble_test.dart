import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/chat/chat_bubble.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

import 'utils/pump_widget.dart';

void main() {
  testWidgets('ChatBubble positions on correct side', (tester) async {
    await runPerf(() async {
      await pumpWithMaterial(
        tester,
        Column(
          children: const [
            ChatBubble(message: 'user', isCurrentUser: true),
            ChatBubble(message: 'bot', isCurrentUser: false),
          ],
        ),
      );

      final bubbles = find.byType(ChatBubble);
      expect(bubbles, findsNWidgets(2));

      final first = tester.getTopRight(bubbles.first);
      final second = tester.getTopLeft(bubbles.last);
      expect(first.dx, greaterThan(second.dx));
    }, name: 'widget_chat_bubble_alignment');
  });
}
