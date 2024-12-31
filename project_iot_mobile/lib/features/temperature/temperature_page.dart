import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({Key? key}) : super(key: key);

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  String temperature = "Awaiting...";

  Future<void> fetchTemperature() async {
    const apiUrl = "http://172.20.10.3/temperature";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tempValue = "${data['temperature']} °C";

        setState(() {
          temperature = tempValue;
        });

        // Save data to Firebase
        FirebaseFirestore.instance.collection('statistics').add({
          'type': 'Temperature',
          'value': tempValue,
          'timestamp': DateTime.now().toString(),
        });
      } else {
        setState(() {
          temperature = "Error ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        temperature = "Connection Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Temperature",
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
                      Icons.thermostat_outlined,
                      size: 100,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      temperature,
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
                  "Get Temperature",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: fetchTemperature,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
