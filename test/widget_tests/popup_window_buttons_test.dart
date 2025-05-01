import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import '../utils/benchmark_helper.dart';
import 'utils/pump_widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('PopupWindow sets confirmed flag', (tester) async {
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

    await runPerf(() async {
      final confirmButton = find.byKey(const Key('popupConfirmBtn'));
      expect(confirmButton, findsOneWidget);

      final button = tester.widget<RectangularButton>(confirmButton);
      button.onPressed.call();

      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    }, name: 'widget_popup_confirm');
  });
}
