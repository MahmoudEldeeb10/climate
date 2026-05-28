import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:climate/features/home/data/models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Change these to use device GPS later if needed
  static const double _latitude = 27;
  static const double _longitude = 30;

  Future<WeatherModel> fetchWeather() async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': _latitude.toString(),
        'longitude': _longitude.toString(),
        'daily': 'sunrise,sunset',
        'hourly':
            'temperature_2m,wind_speed_10m,uv_index,relative_humidity_2m',
        'current': 'wind_speed_10m,wind_direction_10m',
        'timezone': 'Africa/Cairo',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch weather: ${response.statusCode}');
    }
  }
}
