import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LEDControlPage extends StatefulWidget {
  const LEDControlPage({Key? key}) : super(key: key);

  @override
  State<LEDControlPage> createState() => _LEDControlPageState();
}

class _LEDControlPageState extends State<LEDControlPage> {
  String ledStatus = "LED is OFF";

  Future<void> toggleLED() async {
    const apiUrl = "http://172.20.10.3/toggle-led";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      setState(() {
        ledStatus = response.body;
      });
    } catch (e) {
      setState(() {
        ledStatus = "Connection Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LED Control",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
                  Icons.lightbulb_outline,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),
                Text(
                  "Status: $ledStatus",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                  ),
                  icon: const Icon(Icons.power_settings_new, size: 28),
                  label: const Text(
                    "Toggle LED",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: toggleLED,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
