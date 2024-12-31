import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalLogManager {
  static final List<Map<String, String>> _logEntries = [];

  static void addLogEntry(String type, String value) async {
    final now = DateTime.now();
    final formattedTime = "${now.day}/${now.month}/${now.year} at ${now.hour}:${now.minute}";
    final entry = {
      "type": type,
      "value": value,
      "timestamp": formattedTime,
    };

    // Add to local log
    _logEntries.add(entry);

    // Save to Firestore
    try {
      await FirebaseFirestore.instance.collection('logs').add(entry);
    } catch (e) {
      print("Failed to log to Firestore: $e");
    }
  }

  static List<Map<String, String>> getLogs() => _logEntries;
}
