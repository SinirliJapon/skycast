import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skycast/models/weather_model.dart';

class WeatherService {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String geoBaseUrl = "https://api.openweathermap.org/geo/1.0/direct";
  final String oneCallUrl = "https://api.openweathermap.org/data/3.0/onecall";

  final Map<String, WeatherModel> _cache = {};

  Future<WeatherModel> fetchWeather(String cityName) async {
    if (_cache.containsKey(cityName)) {
      return _cache[cityName]!;
    }

    final String apiKey = dotenv.env['API_KEY'] ?? "";
    final String url = "$baseUrl?q=$cityName&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weather = WeatherModel.fromJson(data);

      _cache[cityName] = weather;
      return weather;
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }

  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    final String apiKey = dotenv.env['API_KEY'] ?? "";
    final String url = "$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }

  Future<List<String>> fetchCitySuggestions(String query) async {
    if (query.isEmpty) return [];

    final String apiKey = dotenv.env['API_KEY'] ?? "";
    final String url = "$geoBaseUrl?q=$query&limit=5&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((city) => "${city['name']}, ${city['country']}").toList();
    } else {
      return [];
    }
  }
}