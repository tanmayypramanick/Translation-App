// translation_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationApi {
  final String apiKey;
  final Uri endpoint;

  TranslationApi(this.apiKey, String endpoint) : endpoint = Uri.parse(endpoint);

  Future<String> translate(String text, String targetLanguage) async {
    final response = await http.post(
      endpoint,
      body: {
        'q': text,
        'target': targetLanguage,
        'key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final translatedText =
          decoded['data']['translations'][0]['translatedText'];
      return translatedText;
    } else {
      throw Exception(
          'Failed to translate text. Error code: ${response.statusCode}');
    }
  }
}
