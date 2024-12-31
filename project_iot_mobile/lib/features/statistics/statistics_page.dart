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
  List<String> temperatureTimestamps = [];

  List<FlSpot> luminosityData = [];
  List<String> luminosityTimestamps = [];

  List<FlSpot> seuilData = [];
  List<String> seuilTimestamps = [];

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

    setState(() {
      // Process temperature data
      temperatureData = [];
      temperatureTimestamps = [];
      for (var i = 0; i < tempDocs.docs.length; i++) {
        final value = tempDocs.docs[i]['value'].toDouble();
        final DateTime dateTime = tempDocs.docs[i]['timestamp'].toDate();
        final formattedTime = "${dateTime.hour}:${dateTime.minute}";
        // Add only unique timestamps
        temperatureData.add(FlSpot(i.toDouble(), value));
        temperatureTimestamps.add(formattedTime);
      }

      // Process luminosity data
      luminosityData = [];
      luminosityTimestamps = [];
      for (var i = 0; i < lumDocs.docs.length; i++) {
        final value = lumDocs.docs[i]['value'].toDouble();
        final DateTime dateTime = lumDocs.docs[i]['timestamp'].toDate();
        final formattedTime = "${dateTime.hour}:${dateTime.minute}";
        // Add only unique timestamps
        luminosityData.add(FlSpot(i.toDouble(), value));
        luminosityTimestamps.add(formattedTime);
      }

      // Process seuil data
      seuilData = [];
      seuilTimestamps = [];
      for (var i = 0; i < seuilDocs.docs.length; i++) {
        final value = seuilDocs.docs[i]['value'].toDouble();
        final DateTime dateTime = seuilDocs.docs[i]['timestamp'].toDate();
        final formattedTime = "${dateTime.hour}:${dateTime.minute}";
        // Add only unique timestamps
        seuilData.add(FlSpot(i.toDouble(), value));
        seuilTimestamps.add(formattedTime);
      }
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
                timestamps: temperatureTimestamps,
              ),
              const SizedBox(height: 20),
              _buildGraphSection(
                title: "Luminosity Statistics",
                icon: Icons.light_mode,
                color: Colors.orangeAccent,
                data: luminosityData,
                yLabel: "Lux",
                timestamps: luminosityTimestamps,
              ),
              const SizedBox(height: 20),
              _buildGraphSection(
                title: "Seuil Updates",
                icon: Icons.settings_suggest,
                color: Colors.green,
                data: seuilData,
                yLabel: "Seuil",
                timestamps: seuilTimestamps,
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
    required List<String> timestamps,
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
          Text(
            yLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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
            height: 250,
            child: LineChart(
              LineChartData(
                minY: data.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5,
                maxY: data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 10,
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitles: (value) => value.toInt().toString(),
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitles: (value) {
                      final int index = value.toInt();
                      if (index >= 0 && index < timestamps.length) {
                        return timestamps[index]; // Display only the corresponding timestamp
                      }
                      return ''; // Show nothing for out-of-bounds indices
                    },
                    interval: 1, // Ensure only one timestamp per interval
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

}