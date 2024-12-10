class GlobalLogManager {
  static final List<Map<String, String>> _logEntries = [];

  static void addLogEntry(String type, String value) {
    final now = DateTime.now();
    final formattedTime = "${now.day}/${now.month}/${now.year} at ${now.hour}:${now.minute}";
    _logEntries.add({
      "type": type,
      "value": value,
      "timestamp": formattedTime,
    });
  }

  static List<Map<String, String>> getLogs() => _logEntries;
}
