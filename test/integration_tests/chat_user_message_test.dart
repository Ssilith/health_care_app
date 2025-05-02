import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/chat/chat_page.dart';
import 'package:health_care_app/services/chat_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../utils/benchmark_helper.dart';
import 'utils/mocks.mocks.dart';

void main() {
  testWidgets('advanced_chat_interaction', (tester) async {
    chat.clear();

    final mockClient = MockClient();

    when(
      mockClient.post(
        argThat(isA<Uri>()),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode({
          'choices': [
            {
              'message': {
                'content':
                    'Hello, I am your healthcare assistant. How can I help you today?',
              },
            },
          ],
        }),
        200,
      ),
    );

    final chatService = ChatService(client: mockClient);

    await runPerf(() async {
      await tester.pumpWidget(
        MaterialApp(home: ChatPage(chatService: chatService)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        'Hello, I have a question about my medication',
      );
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(
        find.text('Hello, I have a question about my medication'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Hello, I am your healthcare assistant. How can I help you today?',
        ),
        findsOneWidget,
      );

      when(
        mockClient.post(
          argThat(isA<Uri>()),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'choices': [
              {
                'message': {
                  'content':
                      'Please consult your doctor before changing medication dosage.',
                },
              },
            ],
          }),
          200,
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Can I increase my dosage?',
      );
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(
        find.text('Hello, I have a question about my medication'),
        findsOneWidget,
      );
      expect(find.text('Can I increase my dosage?'), findsOneWidget);
      expect(
        find.text(
          'Please consult your doctor before changing medication dosage.',
        ),
        findsOneWidget,
      );

      expect(chat.length, 4);
      expect(chat[0].isUserMessage, isTrue);
      expect(chat[1].isUserMessage, isFalse);
      expect(chat[2].isUserMessage, isTrue);
      expect(chat[3].isUserMessage, isFalse);
    }, name: 'advanced_chat_interaction');
  });
}
