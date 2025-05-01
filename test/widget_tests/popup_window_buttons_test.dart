import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/popup_window.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('PopupWindow calls onPressed on confirm', (tester) async {
    var confirmed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return PopupWindow(
              title: 'Delete',
              message: 'sure?',
              onPressed: () {
                confirmed = true;
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );

    await runPerf(() async {
      await tester.tap(find.text('Confirm'));
      expect(confirmed, isTrue);
    }, name: 'widget_popup_confirm');
  });
}
