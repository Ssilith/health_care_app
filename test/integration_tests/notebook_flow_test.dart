import 'package:flutter_test/flutter_test.dart';
import '../utils/benchmark_helper.dart';
import 'utils/common_actions.dart';

void main() {
  testWidgets('notebook CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();

      await login(tester);
      await tester.tap(find.text('Med notebook'));
      await tester.pumpAndSettle();

      await createNote(tester);
      await deleteNote(tester);
    }, name: 'integ_notebook_crud');
  });
}
