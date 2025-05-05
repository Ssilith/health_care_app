import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:health_care_app/widgets/text_input_form.dart';
import 'utils/golden_helper.dart';

void main() {
  testGoldens('TextInputForm – empty', (tester) async {
    final ctrl = TextEditingController();
    await goldenPerf(
      tester,
      TextInputForm(width: 300, hint: 'Enter text', controller: ctrl),
      'text_input_form_empty',
      surfaceSize: const Size(320, 60),
    );
  });

  testGoldens('TextInputForm – obscured', (tester) async {
    final ctrl = TextEditingController(text: 'secret');
    await goldenPerf(
      tester,
      TextInputForm(
        width: 300,
        hint: 'Password',
        controller: ctrl,
        hideText: true,
      ),
      'text_input_form_obscure',
      surfaceSize: const Size(320, 60),
    );
  });
}
