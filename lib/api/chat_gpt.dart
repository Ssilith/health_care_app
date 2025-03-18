// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:http/http.dart' as http;

const String url = 'https://api.openai.com/v1/chat/completions';
List<Map> chatMessages = [];

Future<String> getApiKey() async {
  try {
    final String response = await rootBundle.loadString('assets/secrets.json');
    final configData = await json.decode(response);
    return configData['api_key'];
  } catch (e) {
    return "";
  }
}

Future<String> fetchChatGPTResponse(String prompt, BuildContext context) async {
  try {
    String apiKey = await getApiKey();

    var requestBody = jsonEncode({
      'model': 'gpt-3.5-turbo',
      "messages": [
        {
          "role": "user",
          "content": 'Summarize the following text impersonal: \n\n$prompt'
        }
      ],
      'max_tokens': 1000
    });

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      displayErrorMotionToast('Failed to get reponse', context);
      return "";
    }
  } catch (e) {
    displayErrorMotionToast('Error occurred. Failed to get reponse', context);
    return "";
  }
}

Future<String> sendPrompt(String prompt, BuildContext context) async {
  try {
    String apiKey = await getApiKey();
    chatMessages.add({"role": "user", "content": prompt});

    var requestBody = jsonEncode({
      'model': 'gpt-3.5-turbo',
      "messages": chatMessages,
      'max_tokens': 1000,
      'temperature': 0.7
    });

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      chatMessages.add(data['choices'][0]['message']);
      return data['choices'][0]['message']['content'];
    } else {
      displayErrorMotionToast('Failed to fetch data', context);
      return "";
    }
  } catch (e) {
    displayErrorMotionToast('Error occurred', context);
    return "";
  }
}
