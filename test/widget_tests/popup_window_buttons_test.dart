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

    await runPerf(() async {
      final back = find.byKey(const Key('popupConfirmBtn'));
      await tester.ensureVisible(back);
      await tester.tap(back);
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    }, name: 'widget_popup_confirm');
  });
}
