import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/action_container.dart';
import 'package:flutter/material.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('ActionContainer calls onTap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ActionContainer(
          title: 'Chat bot',
          iconData: Icons.chat,
          onTap: () => tapped = true,
        ),
      ),
    );

    await runPerf(() async {
      await tester.tap(find.byType(ActionContainer));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    }, name: 'widget_action_tap');
  });
}
