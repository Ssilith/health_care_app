import 'package:flutter_test/flutter_test.dart';
import 'utils/common_actions.dart';
import '../utils/benchmark_helper.dart';

void main() {
  testWidgets('notebook CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();
      await createNote(tester);
      await editNote(tester);
      await deleteNote(tester);
    }, name: 'integ_notebook_crud');
  });
}
