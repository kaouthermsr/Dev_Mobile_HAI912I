import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class LuminosityPage extends StatefulWidget {
  const LuminosityPage({Key? key}) : super(key: key);

  @override
  State<LuminosityPage> createState() => _LuminosityPageState();
}

class _LuminosityPageState extends State<LuminosityPage> {
  String luminosity = "Awaiting...";

  Future<void> fetchLuminosity() async {
    const apiUrl = "http://172.20.10.3/luminosite";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lumValue = "${data['luminosite']} lux";

        setState(() {
          luminosity = lumValue;
        });

        // Save data to Firebase
        FirebaseFirestore.instance.collection('statistics').add({
          'type': 'Luminosity',
          'value': lumValue,
          'timestamp': DateTime.now().toString(),
        });
      } else {
        setState(() {
          luminosity = "Error ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        luminosity = "Connection Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Luminosity",
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
                width: MediaQuery.of(context).size.width * 0.8,
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
                      color: Colors.yellowAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      luminosity,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                icon: const Icon(Icons.refresh, size: 28),
                label: const Text(
                  "Get Luminosity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: fetchLuminosity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
