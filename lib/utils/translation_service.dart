// translation_service.dart
import 'translation_api.dart';

class TranslationService {
  final TranslationApi _translationApi;

  TranslationService(this._translationApi);

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      return await _translationApi.translate(text, targetLanguage);
    } catch (e) {
      print('Error during translation: $e');
      return 'Translation error';
    }
  }
}
