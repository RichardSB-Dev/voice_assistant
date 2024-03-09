import "package:flutter/material.dart";
import "package:voice_assitant/Components/featureBox.dart";
import "package:voice_assitant/Theme/Pallete.dart";
import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables
  final speechToText = SpeechToText();
  String? generatedContent;
  String? generatedImageUrl;
  String lastWords = '';

  //metodos
  Future<void> initTextToSpeech() async {
    //await flutterTts.setSharedInstance(true); //***** */
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak() async {
    //await flutterTts.speak(content); //**** */
  }
  //

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rich'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // imagen del asistente virtual
          Stack(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 123,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/virtualAssistant.png'))),
              ),
            ],
          ),
          // chat bubble
          Container(
            //fadeInRight
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
              top: 30,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Pallete.borderColor,
              ),
              borderRadius: BorderRadius.circular(20).copyWith(
                topLeft: Radius.zero,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                generatedContent == null
                    ? 'Hola, con que pregunta puedo ayudarte?'
                    : generatedContent!,
                style: TextStyle(
                  fontFamily: 'Cero Pro',
                  color: Pallete.mainFontColor,
                  fontSize: generatedContent == null ? 25 : 18,
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
          Container(
            //slideInLeft
            child: Visibility(
              visible: generatedImageUrl == null && generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, left: 22),
                child: const Text(
                  'Aqui hay algunas opciones:',
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // lista de opciones
          Visibility(
            visible: generatedContent == null && generatedImageUrl == null,
            child: Column(
              children: [
                Container(
                  //slideInLeft
                  child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPR',
                      descriptionText:
                          'Una forma más inteligente de mantenerse organizado e informado con ChatGPT'),
                ),
                Container(
                  //slideInLeft
                  child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descriptionText:
                          'Inspírate y mantente creativo con tu asistente personal desarrollado por Dall-E'),
                ),
                Container(
                  //slideInLeft
                  child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Obtenga lo mejor de ambos mundos con un asistente de voz desarrollado por Dall-E y ChatGPT'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic,
        ),
      ),
    );
  }
}
