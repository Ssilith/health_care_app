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
                Navigator.of(context).pop();
              },
            ),
      ),
      settle: true,
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.text('Confirm'), findsOneWidget);

    await runPerf(() async {
      final confirmButton = find.text('Confirm');
      expect(confirmButton, findsOneWidget);
      await tester.ensureVisible(confirmButton);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(confirmButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(confirmed, isTrue);
    }, name: 'widget_popup_confirm');
  });
}
