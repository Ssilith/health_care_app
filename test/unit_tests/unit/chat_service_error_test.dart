import 'package:flutter_test/flutter_test.dart';
import '../utils/benchmark_helper.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:health_care_app/services/chat_service.dart';

void main() {
  group('ChatService error handling', () {
    test('fetchChatGPTResponse returns empty string on non-200', () async {
      final client = MockClient((_) async => http.Response('fail', 500));
      final svc = ChatService(client: client);

      await runPerf(() async {
        final r = await svc.fetchChatGPTResponse('ignored');
        expect(r, isEmpty);
      }, name: 'chat_fetch_error');
    });
  });
}
