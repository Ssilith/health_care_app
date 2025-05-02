import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as m;

import 'package:health_care_app/chat/chat_page.dart';
import 'package:health_care_app/services/chat_service.dart';

import '../utils/benchmark_helper.dart';
import 'utils/chat_user_message_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  testWidgets('chat_user_message', (tester) async {
    final mockClient = MockClient();

    m
        .when(
          mockClient.post(
            m.argThat(isA<Uri>()),
            headers: m.anyNamed('headers'),
            body: m.anyNamed('body'),
          ),
        )
        .thenAnswer(
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
