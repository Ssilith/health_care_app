import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/notebook/notebook_form.dart';
import '../utils/benchmark_helper.dart';
import 'utils/pump_widget.dart';

void main() {
  testWidgets('NotebookForm prevents empty submit', (tester) async {
    await pumpWithMaterial(tester, NotebookForm(onChange: (_) {}));
    await runPerf(() async {
      await tester.tap(find.text('SUBMIT'), warnIfMissed: false);
      await tester.pump();
    }, name: 'widget_notebook_empty_validation');
  });
}
