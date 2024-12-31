import 'package:flutter/material.dart';
import 'package:project_iot_mobile/features/luminosity/seuil_control_page.dart';
import '../temperature/temperature_page.dart';
import '../luminosity/luminosity_page.dart';
import '../LED/led_control_page.dart';
import '../morse/morse_code_page.dart';
import '../statistics/statistics_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Temperature",
        "icon": Icons.thermostat_outlined,
        "color": Colors.redAccent,
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TemperaturePage()),
        ),
      },
      {
        "title": "Luminosity",
        "icon": Icons.lightbulb_outline,
        "color": Colors.yellow.shade700,
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LuminosityPage()),
        ),
      },
      {
        "title": "LED Control",
        "icon": Icons.light_mode,
        "color": Colors.blueAccent,
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LEDControlPage()),
        ),
      },
      {
        "title": "Morse Code",
        "icon": Icons.code,
        "color": Colors.green,
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MorseCodePage()),
        ),
      },
      {
        "title": "Contrôle du Seuil",
        "icon": Icons.contrast_rounded,
        "color": Colors.pinkAccent,
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SeuilControlPage()),
        ),
      },

      {
        "title": "Statistics",
        "icon": Icons.bar_chart,
        "color": Colors.purple,
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatisticsPage()),
        ),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ESP32 Control Hub",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the ESP32 Control App!\n\n"
                  "Use the buttons below to control and monitor your ESP32.\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three items per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2, // More balanced size
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuCard(
                    context,
                    title: item['title']!,
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                    onTap: item['action'] as VoidCallback,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30, // Smaller Icon Size
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14, // Smaller Font Size
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
