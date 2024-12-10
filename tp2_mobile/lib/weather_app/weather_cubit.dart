import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class WeatherState {
  final bool isLoading;
  final Map<String, dynamic>? weatherData;
  final List<Map<String, dynamic>>? forecastData;
  final String? errorMessage;

  WeatherState({
    required this.isLoading,
    this.weatherData,
    this.forecastData,
    this.errorMessage,
  });

  factory WeatherState.initial() {
    return WeatherState(
      isLoading: false,
      weatherData: null,
      forecastData: null,
      errorMessage: null,
    );
  }

  WeatherState copyWith({
    bool? isLoading,
    Map<String, dynamic>? weatherData,
    List<Map<String, dynamic>>? forecastData,
    String? errorMessage,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      weatherData: weatherData ?? this.weatherData,
      forecastData: forecastData ?? this.forecastData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherState.initial());

  final String _apiKey = "02052e5821c31054e558e04cdbe17acb";
  final String _baseUrl = "https://api.openweathermap.org/data/2.5/";

  Future<void> fetchWeather(String cityName) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, weatherData: null),
    );

    try {
      final encodedCityName = Uri.encodeComponent(cityName);
      final weatherUrl = Uri.parse(
        "${_baseUrl}weather?q=$encodedCityName&appid=$_apiKey&units=metric&lang=fr",
      );
      final forecastUrl = Uri.parse(
        "${_baseUrl}forecast?q=$encodedCityName&appid=$_apiKey&units=metric&lang=fr",
      );

      final weatherResponse = await http.get(weatherUrl);
      final forecastResponse = await http.get(forecastUrl);

      if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final weatherData = jsonDecode(weatherResponse.body);
        final forecastData = jsonDecode(forecastResponse.body);

        // Group forecasts by day
        final Map<String, List<Map<String, dynamic>>> groupedForecasts = {};
        for (var item in forecastData['list']) {
          final date = item['dt_txt'].split(' ')[0]; // Extract the date
          final temp = (item['main']['temp'] ?? 0).toDouble();
          final description = item['weather'][0]['main'];
          final windSpeed = (item['wind']['speed'] ?? 0).toDouble();
          final humidity = (item['main']['humidity'] ?? 0).toInt();

          if (!groupedForecasts.containsKey(date)) {
            groupedForecasts[date] = [];
          }
          groupedForecasts[date]!.add({
            'temp': temp,
            'description': description,
            'wind': windSpeed,
            'humidity': humidity,
          });
        }

        // Calculate daily summaries
        final List<Map<String, dynamic>> dailySummaries = groupedForecasts.entries.map<Map<String, dynamic>>((entry) {
          final temps = entry.value.map<double>((e) => e['temp']).toList();
          final descriptions = entry.value.map<String>((e) => e['description']).toSet().toList();
          final windSpeeds = entry.value.map<double>((e) => e['wind']).toList();
          final humidities = entry.value.map<int>((e) => e['humidity']).toList();

          return {
            'date': entry.key,
            'maxTemp': temps.reduce((a, b) => a > b ? a : b), // Max temperature of the day
            'minTemp': temps.reduce((a, b) => a < b ? a : b), // Min temperature of the day
            'description': descriptions.join(', '),
            'windSpeed': windSpeeds.isNotEmpty ? windSpeeds.reduce((a, b) => a + b) / windSpeeds.length : 0.0,
            'humidity': humidities.isNotEmpty ? humidities.reduce((a, b) => a + b) ~/ humidities.length : 0,
          };
        }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            weatherData: weatherData,
            forecastData: dailySummaries,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Ville non trouvée ou problème de connexion.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Erreur : ${e.toString()}. Vérifiez votre connexion.",
        ),
      );
    }
  }


}