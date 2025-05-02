import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

import 'package:health_care_app/chat/chat_page.dart';
import 'package:health_care_app/services/chat_service.dart';

import '../utils/benchmark_helper.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  testWidgets('chat_user_message', (tester) async {
    final mockClient = MockClient();

    when(
      mockClient.post(
        Uri(),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode({
          'choices': [
            {
              'message': {'content': 'Hi, how can I help you?'},
            },
          ],
        }),
        200,
      ),
    );

    ChatService.overrideClientForTests(mockClient);

    await runPerf(() async {
      await tester.pumpWidget(const MaterialApp(home: ChatPage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi, how can I help you?'), findsOneWidget);
    }, name: 'chat_user_message');
  });
}
