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
    expect(find.byKey(const Key('visibilityToggle')), findsOneWidget);

    await runPerf(() async {
      expect(find.text('secret'), findsNothing);
      await tester.tap(find.byKey(const Key('visibilityToggle')));
      await tester.pumpAndSettle();
      expect(find.text('secret'), findsOneWidget);
    }, name: 'widget_textinput_obscure_toggle');
  });
}
