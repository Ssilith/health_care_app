import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('RectangularButton disables on loading', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: RectangularButton(
          title: 'Save',
          isLoading: true,
          onPressed: () => tapped = true,
        ),
      ),
    );

    await runPerf(() async {
      await tester.tap(find.byType(RectangularButton));
      expect(tapped, isFalse);
    }, name: 'widget_rectangular_button_disabled');
  });
}
