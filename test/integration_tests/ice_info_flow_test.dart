import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/ice/main_ice.dart';
import 'package:health_care_app/services/repository_impl.dart';

import '../utils/benchmark_helper.dart';
import 'utils/hint_text_finder.dart';
import 'utils/mock_repository.dart';

void main() {
  setUpAll(() {
    RepositoryImpl.inject(MockRepository() as RepositoryImpl);
  });

  testWidgets('ice_info_crud', (tester) async {
    await runPerf(() async {
      await tester.pumpWidget(MaterialApp(home: MainIce()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byHintText('Full Name'), 'Alice Smith');
      await tester.enterText(find.byHintText('Birth Date'), '2000-01-01');
      await tester.enterText(find.byHintText('Gender'), 'Female');

      await tester.ensureVisible(find.text('SUBMIT'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('SUBMIT'));
      await tester.pumpAndSettle();

      expect(find.text('Alice Smith'), findsOneWidget);

      await tester.drag(find.text('Alice Smith'), const Offset(300, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.ensureVisible(find.text('Confirm'));
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Alice Smith'), findsNothing);
    }, name: 'ice_info_crud');
  });
}
