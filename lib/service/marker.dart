import 'dart:convert';
import 'package:essai/constants.dart';
import 'package:http/http.dart' as http;

Future<dynamic> sendRequest(String apiKey, String text) async {
  final Uri marker = Uri(
    scheme: 'https',
    host: 'api.openai.com',
    path: '/v1/engines/text-davinci-002/jobs/',
  );
  final response = await http.post(marker,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: json.encode({'text': text, 'model': 'davinci'}));

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    final generatedText = responseJson['choices'][0]['text'];
    print(generatedText);
  } else {
    print('Request failed with status code: ${response.statusCode}');
  }

  return response;
}

Future<String> generateResponse(String prompt) async {
  final apiKey = ApiKeys.apiKey;

  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      'temperature': 0,
      'max_tokens': 2000,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  // Do something with the response
  Map<String, dynamic> newresponse = jsonDecode(response.body);

  return newresponse['choices'][0]['text'];
}
