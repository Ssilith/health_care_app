import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/services/chat_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../utils/benchmark_helper.dart';

void main() {
  group('ChatService Tests', () {
    test('fetchChatGPTResponse returns expected content', () async {
      final fakeResponse = {
        "choices": [
          {
            "message": {"content": "Expected response"},
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final chatService = ChatService(client: client);

      await runPerf(() async {
        await chatService.fetchChatGPTResponse("dummy prompt");
      }, name: 'chat_fetchChatGPTResponse');

      final response = await chatService.fetchChatGPTResponse("dummy prompt");
      expect(response, equals("Expected response"));
    });

    test('sendPrompt returns expected content', () async {
      final fakeResponse = {
        "choices": [
          {
            "message": {"content": "Prompt reply"},
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final chatService = ChatService(client: client);

      await runPerf(() async {
        await chatService.sendPrompt("Hello");
      }, name: 'chat_sendPrompt');

      final response = await chatService.sendPrompt("Hello");
      expect(response, equals("Prompt reply"));
    });
  });
}
