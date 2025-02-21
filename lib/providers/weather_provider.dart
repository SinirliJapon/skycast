import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skycast/models/weather_model.dart';
import 'package:skycast/services/weather_service.dart';
import 'package:skycast/services/location_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  String _errorMessage = "";
  WeatherModel? _weather;
  List<String> _citySuggestions = [];

  final Map<String, List<String>> _citySuggestionsCache = {};

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<String> get citySuggestions => _citySuggestions;

  Future<void> fetchWeatherByCity(String cityName) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      _weather = await _weatherService.fetchWeather(cityName);
      _citySuggestionsCache[cityName] = [_weather!.cityName];

    } catch (e) {
      _errorMessage = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      Position position = await _locationService.getCurrentLocation();
      _weather = await _weatherService.fetchWeatherByLocation(
          position.latitude, position.longitude);

    } catch (e) {
      _errorMessage = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      _citySuggestions = [];
      if (_weather != null) {
        _citySuggestions.add(_weather!.cityName);
      }
    } else {
      if (_citySuggestionsCache.containsKey(query)) {
        _citySuggestions = _citySuggestionsCache[query]!;
      } else {
        _citySuggestions = await _weatherService.fetchCitySuggestions(query);
        _citySuggestionsCache[query] = _citySuggestions;
      }
    }

    notifyListeners();
  }
}