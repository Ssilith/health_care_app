import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/text_input_form.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

import 'utils/pump_widget.dart';

void main() {
  testWidgets('TextInputForm toggles obscured text', (tester) async {
    final controller = TextEditingController(text: 'secret');

    await pumpWithMaterial(
      tester,
      TextInputForm(
        width: 300,
        hint: 'Password',
        controller: controller,
        hideText: true,
      ),
    );

    await tester.pumpAndSettle();

    final initialText = tester.widget<EditableText>(find.byType(EditableText));
    expect(initialText.obscureText, isTrue);

    await runPerf(() async {
      final toggleButton = find.byKey(const Key('visibilityToggle'));
      final toggleRect = tester.getRect(toggleButton);
      await tester.tapAt(toggleRect.center);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      final updatedText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(updatedText.obscureText, isFalse);
    }, name: 'widget_textinput_obscure_toggle');
  });
}
