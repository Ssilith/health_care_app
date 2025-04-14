import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String chatApiUrl = 'https://api.openai.com/v1/chat/completions';

class ChatService {
  final http.Client client;
  ChatService({http.Client? client}) : client = client ?? http.Client();

  Future<String> getApiKey() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/secrets.json',
      );
      final configData = json.decode(response);
      return configData['api_key'];
    } catch (e) {
      return "";
    }
  }

  Future<String> fetchChatGPTResponse(String prompt) async {
    try {
      String apiKey = await getApiKey();
      var requestBody = jsonEncode({
        'model': 'gpt-3.5-turbo',
        "messages": [
          {
            "role": "user",
            "content": 'Summarize the following text impersonal: \n\n$prompt',
          },
        ],
        'max_tokens': 1000,
      });

      var response = await client.post(
        Uri.parse(chatApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<String> sendPrompt(String prompt) async {
    try {
      String apiKey = await getApiKey();
      List<Map<String, dynamic>> chatMessages = [
        {"role": "user", "content": prompt},
      ];

      var requestBody = jsonEncode({
        'model': 'gpt-3.5-turbo',
        "messages": chatMessages,
        'max_tokens': 1000,
        'temperature': 0.7,
      });

      var response = await client.post(
        Uri.parse(chatApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }
}
