import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import '../utils/benchmark_helper.dart';

import 'utils/pump_widget.dart';

void main() {
  testWidgets('RectangularButton disables on loading', (tester) async {
    var tapped = false;

    await pumpWithMaterial(
      tester,
      RectangularButton(
        title: 'Save',
        isLoading: true,
        onPressed: () => tapped = true,
      ),
    );

    await runPerf(() async {
      await tester.tap(find.byType(RectangularButton), warnIfMissed: false);
      expect(tapped, isFalse);
    }, name: 'widget_rectangular_button_disabled');
  });
}
