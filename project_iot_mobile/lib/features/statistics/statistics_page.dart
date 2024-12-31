import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<FlSpot> temperatureData = [];
  List<FlSpot> luminosityData = [];
  List<FlSpot> seuilData = [];
  List<Map<String, dynamic>> ledLogs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final tempDocs = await FirebaseFirestore.instance
        .collection('temperature')
        .orderBy('timestamp')
        .get();
    final lumDocs = await FirebaseFirestore.instance
        .collection('luminosity')
        .orderBy('timestamp')
        .get();
    final seuilDocs = await FirebaseFirestore.instance
        .collection('seuil')
        .orderBy('timestamp')
        .get();
    final ledDocs = await FirebaseFirestore.instance
        .collection('led_logs')
        .orderBy('timestamp')
        .get();

    setState(() {
      temperatureData = tempDocs.docs.asMap().entries.map((entry) {
        final index = entry.key.toDouble();
        final value = entry.value['value'].toDouble();
        return FlSpot(index, value);
      }).toList();

      luminosityData = lumDocs.docs.asMap().entries.map((entry) {
        final index = entry.key.toDouble();
        final value = entry.value['value'].toDouble();
        return FlSpot(index, value);
      }).toList();

      seuilData = seuilDocs.docs.asMap().entries.map((entry) {
        final index = entry.key.toDouble();
        final value = entry.value['value'].toDouble();
        return FlSpot(index, value);
      }).toList();

      ledLogs = ledDocs.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics Overview",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGraphSection(
                title: "Temperature Statistics",
                icon: Icons.thermostat_outlined,
                color: Colors.redAccent,
                data: temperatureData,
                yLabel: "°C",
              ),
              const SizedBox(height: 20),
              _buildGraphSection(
                title: "Luminosity Statistics",
                icon: Icons.light_mode,
                color: Colors.orangeAccent,
                data: luminosityData,
                yLabel: "Lux",
              ),
              const SizedBox(height: 20),
              _buildGraphSection(
                title: "Seuil Updates",
                icon: Icons.settings_suggest,
                color: Colors.green,
                data: seuilData,
                yLabel: "Seuil",
              ),
              const SizedBox(height: 20),
              _buildLogSection(
                title: "LED Status",
                icon: Icons.lightbulb_circle_outlined,

                logs: ledLogs,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<FlSpot> data,
    required String yLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          data.isEmpty
              ? const Center(
            child: Text(
              "No Data Available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) => "$value",
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) => "$value",
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(),
                    left: BorderSide(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: data,
                    dotData: FlDotData(show: true),
                    colors: [color],
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogSection({
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> logs,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          logs.isEmpty
              ? const Center(
            child: Text(
              "No Logs Available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: Icon(Icons.bolt, color: Colors.blueAccent),
                title: Text("Action: ${log['action']}"),
                subtitle: Text("Timestamp: ${log['timestamp'].toDate()}"),
              );
            },
          ),
        ],
      ),
    );
  }
}
