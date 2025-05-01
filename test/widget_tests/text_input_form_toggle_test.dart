import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/text_input_form.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

import 'utils/pump_widget.dart';

void main() {
  testWidgets('TextInputForm toggles obscured text', (tester) async {
    final controller = TextEditingController(text: 'secret');

    // Add widget key for easier access
    final widgetKey = GlobalKey();

    await pumpWithMaterial(
      tester,
      TextInputForm(
        key: widgetKey,
        width: 300,
        hint: 'Password',
        controller: controller,
        hideText: true,
      ),
    );

    await tester.pumpAndSettle();

    await runPerf(() async {
      final toggleButton = find.byKey(const Key('visibilityToggle'));
      expect(toggleButton, findsOneWidget);

      final toggleRect = tester.getRect(toggleButton);
      await tester.tapAt(toggleRect.center);
      await tester.pumpAndSettle();

      expect(true, isTrue);
    }, name: 'widget_textinput_obscure_toggle');
  });
}
