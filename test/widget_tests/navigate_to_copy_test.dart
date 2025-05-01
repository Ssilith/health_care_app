import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/localization/navigate_to_container.dart';
import '../utils/benchmark_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  testWidgets('NavigateToContainer copies text', (tester) async {
    const text = 'clinic name';

    await tester.pumpWidget(
      MaterialApp(
        home: NavigateToContainer(
          icon: Icons.person,
          title: 'Name',
          mess: text,
        ),
      ),
    );

    await runPerf(() async {
      await tester.tap(find.byIcon(Icons.copy));
      final data = await Clipboard.getData('text/plain');
      expect(data?.text, text);
    }, name: 'widget_navigate_copy');
  });
}
