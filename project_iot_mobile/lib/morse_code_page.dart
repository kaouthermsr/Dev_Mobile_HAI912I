import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MorseCodePage extends StatefulWidget {
  const MorseCodePage({Key? key}) : super(key: key);

  @override
  State<MorseCodePage> createState() => _MorseCodePageState();
}

class _MorseCodePageState extends State<MorseCodePage> {
  final TextEditingController morseController = TextEditingController();
  String morseTranslation = "Awaiting...";

  // Local Morse Translator
  String _translateToMorse(String text) {
    const morseMap = {
      'a': '.-',   'b': '-...', 'c': '-.-.', 'd': '-..',  'e': '.',
      'f': '..-.', 'g': '--.',  'h': '....', 'i': '..',   'j': '.---',
      'k': '-.-',  'l': '.-..', 'm': '--',   'n': '-.',   'o': '---',
      'p': '.--.', 'q': '--.-', 'r': '.-.',  's': '...',  't': '-',
      'u': '..-',  'v': '...-', 'w': '.--',  'x': '-..-', 'y': '-.--',
      'z': '--..', '1': '.----','2': '..---','3': '...--','4': '....-',
      '5': '.....','6': '-....','7': '--...','8': '---..','9': '----.',
      '0': '-----',' ': '/'
    };

    return text.toLowerCase().split('').map((char) {
      return morseMap[char] ?? '?'; // '?' for unknown characters
    }).join(' ');
  }

  // Send Request to the ESP32 API
  Future<void> sendMorseToAPI(String text) async {
    final apiUrl = "http://172.20.10.3/morse?text=$text";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print("Morse code sent successfully to ESP32.");
      } else {
        print("Error sending to ESP32: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  // Handle Translation and Send API Request
  void handleMorseTranslation() {
    final text = morseController.text.trim();
    if (text.isEmpty) {
      setState(() {
        morseTranslation = "Please enter text!";
      });
    } else {
      final translation = _translateToMorse(text);
      setState(() {
        morseTranslation = translation;
      });
      sendMorseToAPI(text); // Trigger API Request
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Morse Code",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.code,
                      size: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: morseController,
                      decoration: const InputDecoration(
                        labelText: "Enter Text",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                      ),
                      icon: const Icon(Icons.send, size: 28),
                      label: const Text(
                        "Send Morse",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: handleMorseTranslation,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Morse Translation:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      morseTranslation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
