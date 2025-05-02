import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/notebook/main_notebook.dart';
import 'package:health_care_app/services/notebook_service.dart';

import '../utils/benchmark_helper.dart';
import 'utils/hint_text_finder.dart';
import 'utils/mock_repository.dart';

void main() {
  testWidgets('notebook_crud', (tester) async {
    final mockRepo = MockRepository();

    final notebookService = NotebookService.withRepository(mockRepo);

    await runPerf(() async {
      await tester.pumpWidget(
        MaterialApp(home: MainNotebook(notebookService: notebookService)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.plus_one));
      await tester.pumpAndSettle();

      await tester.enterText(find.byHintText('Title'), 'My note');
      await tester.enterText(find.byHintText('Content'), 'hello world');
      await tester.tap(find.text('SUBMIT'));
      await tester.pumpAndSettle();

      expect(find.text('My note'), findsOneWidget);

      await tester.tap(find.text('My note'));
      await tester.pump();
      await tester.tap(find.text('My note'));
      await tester.pump();

      await tester.drag(find.text('My note'), const Offset(300, 0));
      await tester.tap(find.text('Delete'));
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('My note'), findsNothing);
    }, name: 'notebook_crud');
  });
}
