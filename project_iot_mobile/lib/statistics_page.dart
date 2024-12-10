import 'package:flutter/material.dart';
import 'log_manager.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logs = GlobalLogManager.getLogs();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics Overview",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
      body: logs.isEmpty
          ? const Center(
        child: Text(
          "No Data Logged Yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(
                log['type'] == "Temperature"
                    ? Icons.thermostat
                    : Icons.lightbulb,
                color: log['type'] == "Temperature"
                    ? Colors.redAccent
                    : Colors.yellowAccent,
              ),
              title: Text(
                "${log['type']} Reading: ${log['value']}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("Recorded at ${log['timestamp']}"),
            ),
          );
        },
      ),
    );
  }
}
