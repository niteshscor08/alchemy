import 'package:alchemy/app_colors.dart';
import 'package:alchemy/feature_suggestion_box.dart';
import 'package:alchemy/open_ai_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkTheme = true; // Default theme is dark

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  // Speech recognition and text-to-speech services
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts textToSpeech = FlutterTts();

  //
  final TextEditingController _messageController = TextEditingController();
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  bool isShowSendButton = false;

  // Text and image generated from user input
  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;

  // Animation durations
  int animationStart = 200; // Initial delay for animations
  int animationDelay = 200; // Delay between animations

  //
  final OpenAIService openAIService = OpenAIService();

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
    initializeTextToSpeech();
  }

  Future<void> initializeTextToSpeech() async {
    await textToSpeech.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initializeSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(
        onResult: onSpeechResult,
      listenFor: const Duration(seconds: 15),
    );
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      if(result.finalResult) {
        lastWords = result.recognizedWords;
        callGPTPrompt(lastWords);
      }
    });
  }

  void callGPTPrompt(String lastWords) async{
    final speech = await openAIService.isArtPrompt(lastWords);
    if (speech.contains('https')) {
      generatedImageUrl = speech;
      generatedContent = null;
      setState(() {});
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      setState(() {});
      await speakText(speech);
    }
    await stopListening();
  }

  Future<void> speakText(String content) async {
    await textToSpeech.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    textToSpeech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.blackColor : AppColors.whiteColor,
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('Alchemy'),
        ),
        leading: const Icon(Icons.menu),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_auto),
            onPressed: toggleTheme,
          ),
        ],
      ),
      // bottomNavigationBar: ,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Virtual assistant image with animation
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? AppColors.darkPrimaryTextColor
                            : AppColors.lightPrimaryTextColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/virtualAssistant.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Chat bubble with generated content or welcome message
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkTheme
                          ? AppColors.darkBorderColor
                          : AppColors.lightBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: isDarkTheme
                            ? AppColors.darkPrimaryTextColor
                            : AppColors.lightPrimaryTextColor,
                        fontSize: generatedContent == null ? 25 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'PoppinsRegular',
                      color: isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // features list
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: animationStart),
                    child: FeatureSuggestionBox(
                      backgroundColor: isDarkTheme
                          ? AppColors.darkSuggestionBoxGradient[0]
                          : AppColors.lightSuggestionBoxGradient[0],
                      featureTitle: 'ChatGPT',
                      featureDescription:
                          'A smarter way to stay organized and informed with ChatGPT',
                      isDarkTheme: isDarkTheme,
                    ),
                  ),
                  SlideInLeft(
                    delay:
                        Duration(milliseconds: animationStart + animationDelay),
                    child: FeatureSuggestionBox(
                      backgroundColor: isDarkTheme
                          ? AppColors.darkSuggestionBoxGradient[1]
                          : AppColors.lightSuggestionBoxGradient[1],
                      featureTitle: 'Dall-E',
                      featureDescription:
                          'Get inspired and stay creative with your personal assistant powered by Dall-E',
                      isDarkTheme: isDarkTheme,
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(
                        milliseconds: animationStart + 2 * animationDelay),
                    child: FeatureSuggestionBox(
                      backgroundColor: isDarkTheme
                          ? AppColors.darkSuggestionBoxGradient[1]
                          : AppColors.lightSuggestionBoxGradient[1],
                      featureTitle: 'Smart Voice Assistant',
                      featureDescription:
                          'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                      isDarkTheme: isDarkTheme,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: animationStart + 3 * animationDelay),
        child: FloatingActionButton(
          backgroundColor: isDarkTheme
          ? AppColors.darkSuggestionBoxGradient[0]
          : AppColors.lightSuggestionBoxGradient[0],
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              print('Listed is called');
              final speech = await openAIService.isArtPrompt(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await speakText(speech);
              }
              await stopListening();
            } else {
              initializeSpeechToText();
            }
          },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}
