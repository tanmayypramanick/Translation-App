import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation_app/models/language_model.dart';
import 'package:translation_app/utils/translation_service.dart';
import 'package:translation_app/utils/translation_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textEditingController1 = TextEditingController();
  late Language _selectedLanguage1;
  late Language _selectedLanguage2;
  String _translatedText = "";
  Color _appBarColor = Color(0xFF285943);

  late TranslationService _translationService;

  @override
  void initState() {
    super.initState();
    _selectedLanguage1 = supportedLanguages[0];
    _selectedLanguage2 = supportedLanguages[0];
    _translationService = TranslationService(
      TranslationApi(
        'AIzaSyAEuMxJPY2zc2_l1iSTJONoTvLDnVcrc1A',
        'https://translation.googleapis.com/language/translate/v2',
      ),
    );
    initSpeech();
  }

  void initSpeech() async {
    _speechToText.initialize(onStatus: (status) {
      setState(() {});
    });
  }

  void _startListening() async {
    await _speechToText.listen(onResult: (result) {
      setState(() {
        _textEditingController1.text = result.recognizedWords;
      });
      _translateText();
    });
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  Future<void> _translateText() async {
    final textToTranslate = _textEditingController1.text;
    final targetLanguage = _selectedLanguage2.code;

    if (textToTranslate.isNotEmpty) {
      final translatedText = await _translationService.translateText(
        textToTranslate,
        targetLanguage,
      );

      setState(() {
        _translatedText = translatedText;
      });
    }
  }

  void _swapLanguages() {
    setState(() {
      final tempLanguage = _selectedLanguage1;
      _selectedLanguage1 = _selectedLanguage2;
      _selectedLanguage2 = tempLanguage;
      _translateText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text(
          'Translation App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4E715D),
              _appBarColor,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green[900]!,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Language>(
                          value: _selectedLanguage1,
                          onChanged: (Language? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedLanguage1 = newValue;
                              });
                            }
                          },
                          style:
                              TextStyle(color: Colors.white), // Set text color
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: supportedLanguages
                              .map<DropdownMenuItem<Language>>(
                                  (Language value) {
                            return DropdownMenuItem<Language>(
                              value: value,
                              child: Text(value.name,
                                  style: TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _speechToText.isNotListening
                              ? Icons.mic
                              : Icons.mic_off,
                          color: Colors.white,
                        ),
                        onPressed: _speechToText.isListening
                            ? _stopListening
                            : _startListening,
                      ),
                    ],
                  ),
                  Container(
                    height: 200, // Increase the desired height
                    child: TextField(
                      controller: _textEditingController1,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      onChanged: (_) => _translateText(),
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText:
                            'Type in or speak by tapping on microphone to translate...',
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            IconButton(
              icon: Icon(
                Icons.swap_horiz,
                size: 30,
                color: Colors.white,
              ),
              onPressed: _swapLanguages,
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green[900]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<Language>(
                            value: _selectedLanguage2,
                            onChanged: (Language? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedLanguage2 = newValue;
                                  _translateText();
                                });
                              }
                            },
                            style: TextStyle(
                                color: Colors.white), // Set text color
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            items: supportedLanguages
                                .map<DropdownMenuItem<Language>>(
                                    (Language value) {
                              return DropdownMenuItem<Language>(
                                value: value,
                                child: Text(value.name,
                                    style: TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          _translatedText,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
