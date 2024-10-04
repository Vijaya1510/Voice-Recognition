import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late stts.SpeechToText speechToText;
  bool isListening = false;
  String text = 'Please press the button to start speaking';

  @override
  void initState() {
    super.initState();
    speechToText = stts.SpeechToText();
  }

  void listen() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) => debugPrint("Status: $status"),
        onError: (errorNotification) => debugPrint("Error: $errorNotification"),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        speechToText.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      speechToText.stop();
    }
  }

  void clearText() {
    setState(() {
      text = 'Please press the button to start speaking';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Speech to Text",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AvatarGlow(
            animate: isListening,
            repeat: true,
            glowColor: Colors.red,
            duration: const Duration(milliseconds: 1000),
            child: FloatingActionButton(
              onPressed: () {
                listen();
              },
              child: Icon(isListening ? Icons.mic : Icons.mic_none),
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: clearText,
            backgroundColor: Colors.white,
            child: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}
