import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/notebook/notebook_form.dart';
import 'package:flutter/material.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('NotebookForm prevents empty submit', (tester) async {
    await tester.pumpWidget(MaterialApp(home: NotebookForm(onChange: (_) {})));

    await runPerf(() async {
      await tester.tap(find.text('SUBMIT'));
      await tester.pump();
    }, name: 'widget_notebook_empty_validation');
  });
}
