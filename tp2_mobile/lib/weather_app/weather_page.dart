import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'weather_cubit.dart';

Widget getWeatherIcon({
  required String weatherDescription,
  required Color color,
  required double size,
}) {
  if (weatherDescription.toLowerCase().contains("clear")) {
    return Icon(FontAwesomeIcons.sun, color: color, size: size);
  } else if (weatherDescription.toLowerCase().contains("cloud")) {
    return Icon(FontAwesomeIcons.cloud, color: color, size: size);
  } else if (weatherDescription.toLowerCase().contains("rain")) {
    return Icon(FontAwesomeIcons.cloudShowersHeavy, color: color, size: size);
  } else if (weatherDescription.toLowerCase().contains("thunderstorm")) {
    return Icon(FontAwesomeIcons.bolt, color: color, size: size);
  } else if (weatherDescription.toLowerCase().contains("snow")) {
    return Icon(FontAwesomeIcons.snowflake, color: color, size: size);
  } else if (weatherDescription.toLowerCase().contains("mist") ||
      weatherDescription.toLowerCase().contains("fog")) {
    return Icon(FontAwesomeIcons.smog, color: color, size: size);
  } else {
    return Icon(FontAwesomeIcons.sun, color: color, size: size); // Default icon
  }
}


class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Météo App",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade400,
        centerTitle: true,
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade300, Colors.blue.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCityInput(cityController, context),
                  const SizedBox(height: 20),
                  if (state.isLoading)
                    const CircularProgressIndicator()
                  else if (state.errorMessage != null)
                    _buildErrorMessage(state.errorMessage!)
                  else if (state.weatherData != null)
                      ...[
                        _buildWeatherInfo(state.weatherData!),
                        const SizedBox(height: 20),
                        if (state.forecastData != null)
                          _buildDayByDayForecast(state.forecastData!),
                      ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCityInput(
      TextEditingController cityController, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8.0,
      child: TextField(
        controller: cityController,
        decoration: InputDecoration(
          labelText: "Entrez une ville",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.teal),
            onPressed: () {
              final cityName = cityController.text;
              if (cityName.isNotEmpty) {
                context.read<WeatherCubit>().fetchWeather(cityName);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWeatherInfo(Map<String, dynamic> weatherData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // City and Country
            Text(
              "${weatherData['name'] ?? 'Unknown City'}, ${weatherData['sys']['country'] ?? ''}",
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Main Weather Icon
            getWeatherIcon(
              weatherDescription: weatherData['weather'][0]['description'] ?? "Unknown",
              color: Colors.teal,
              size: 48.0,
            ),
            const SizedBox(height: 10),

            // Current Temperature
            Text(
              "${(weatherData['main']['temp'] ?? 0.0).toStringAsFixed(1)}°C",
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),

            // Min and Max Temperatures
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.arrowDown,
                      size: 24.0,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      "${(weatherData['main']['temp_min'] ?? 0.0).toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Min",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.arrowUp,
                      size: 24.0,
                      color: Colors.redAccent,
                    ),
                    Text(
                      "${(weatherData['main']['temp_max'] ?? 0.0).toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Max",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Wind and Humidity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.wind,
                      size: 24.0,
                      color: Colors.teal,
                    ),
                    Text(
                      "${(weatherData['wind']['speed'] ?? 0.0).toStringAsFixed(1)} m/s",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Vent",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.water,
                      size: 24.0,
                      color: Colors.blue,
                    ),
                    Text(
                      "${(weatherData['main']['humidity'] ?? 0)}%",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Humidité",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayByDayForecast(List<Map<String, dynamic>> dailySummaries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Prévisions pour les prochains jours :",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        ...dailySummaries.map((day) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            elevation: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            color: Colors.white.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Date and Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day['date'] ?? "Unknown Date",
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        day['description'] ?? "Unknown",
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Weather Icon, Min/Max Temps, Wind, and Humidity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Weather Icon
                      getWeatherIcon(
                        weatherDescription: day['description'] ?? "Unknown",
                        color: Colors.blueAccent,
                        size: 40.0,
                      ),

                      // Min and Max Temperatures
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.arrowDown,
                                size: 16.0,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${(day['minTemp'] ?? 0.0).toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.arrowUp,
                                size: 16.0,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${(day['maxTemp'] ?? 0.0).toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Wind
                      Column(
                        children: [
                          const Icon(
                            FontAwesomeIcons.wind,
                            size: 16.0,
                            color: Colors.teal,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${(day['windSpeed'] ?? 0.0).toStringAsFixed(1)} m/s",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Humidity
                      Column(
                        children: [
                          const Icon(
                            FontAwesomeIcons.water,
                            size: 16.0,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${(day['humidity'] ?? 0)}%",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

}