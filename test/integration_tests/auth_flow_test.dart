import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/auth/login_page_template.dart';

import '../utils/benchmark_helper.dart';
import 'utils/hint_text_finder.dart';

void main() {
  testWidgets('auth_flow', (tester) async {
    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: LoginPageTemplate()));
      await tester.pumpAndSettle();

      // open sign‑up
      await tester.tap(find.textContaining("DON'T HAVE"));
      await tester.pumpAndSettle();

      // enter credentials & submit
      await tester.enterText(find.byHintText('E-mail'), 'user@test.com');
      await tester.enterText(find.byHintText('Password'), '123456');
      await tester.enterText(find.byHintText('Repeat password'), '123456');
      await tester.tap(find.text('SIGN UP'));
      await tester.pumpAndSettle();

      // switch back to log‑in
      await tester.tap(find.textContaining('WANT TO LOG IN'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byHintText('E-mail'), 'user@test.com');
      await tester.enterText(find.byHintText('Password'), '123456');
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle();

      // we land on MyHomePage → press logout icon
      await tester.tap(find.byIcon(Icons.logout_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget); // back on template
    }, name: 'auth_flow');
  });
}
