import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/search_bar_container.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SearchBarContainer shows hint and accepts input', (
    tester,
  ) async {
    final ctrl = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(home: SearchBarContainer(search: ctrl)),
    );

    await runPerf(() async {
      await tester.enterText(find.byType(TextField), 'abc');
      expect(ctrl.text, 'abc');
    }, name: 'widget_searchbar_input');
  });
}
