import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SeuilControlPage extends StatefulWidget {
  const SeuilControlPage({Key? key}) : super(key: key);

  @override
  State<SeuilControlPage> createState() => _SeuilControlPageState();
}

class _SeuilControlPageState extends State<SeuilControlPage> {
  final TextEditingController seuilController = TextEditingController();
  String currentThreshold = "Chargement...";

  // Fetch the current luminosity threshold
  Future<void> fetchThreshold() async {
    const apiUrl = "http://172.20.10.3/get-luminosity-threshold";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          currentThreshold = response.body.split(":").last.trim(); // Extract value
        });
      } else {
        setState(() {
          currentThreshold = "Erreur: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        currentThreshold = "Erreur de connexion";
      });
    }
  }

  // Update the luminosity threshold
  Future<void> updateThreshold() async {
    const apiUrl = "http://172.20.10.3/set-luminosity-threshold";
    final newThreshold = seuilController.text.trim();
    if (newThreshold.isEmpty) {
      setState(() {
        currentThreshold = "Veuillez entrer une valeur !";
      });
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"threshold": newThreshold},
      );
      if (response.statusCode == 200) {
        setState(() {
          currentThreshold = newThreshold;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
      } else {
        setState(() {
          currentThreshold = "Erreur: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        currentThreshold = "Erreur de connexion";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchThreshold(); // Fetch the threshold when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contrôle du Seuil",
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
                      Icons.contrast_rounded,
                      size: 100,
                      color: Colors.pinkAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Seuil actuel : $currentThreshold lux",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: seuilController,
                      decoration: const InputDecoration(
                        labelText: "Entrez un nouveau seuil",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                      ),
                      icon: const Icon(Icons.update, size: 28),
                      label: const Text(
                        "Mettre à jour",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: updateThreshold,
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
