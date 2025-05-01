import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import '../utils/benchmark_helper.dart';
import 'utils/pump_widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('PopupWindow calls onPressed on confirm', (tester) async {
    var confirmed = false;

    await pumpWithMaterial(
      tester,
      Builder(
        builder:
            (context) => PopupWindow(
              title: 'Delete',
              message: 'sure?',
              onPressed: () {
                confirmed = true;
              },
            ),
      ),
      settle: true,
    );

    await tester.pumpAndSettle();

    final buttonFinder = find.descendant(
      of: find.byKey(const Key('popupConfirmBtn')),
      matching: find.byType(InkWell),
    );

    expect(
      buttonFinder,
      findsOneWidget,
      reason: 'Button should have an InkWell',
    );

    await runPerf(() async {
      final buttonRect = tester.getRect(buttonFinder);
      await tester.tapAt(buttonRect.center);
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    }, name: 'widget_popup_confirm');
  });
}
