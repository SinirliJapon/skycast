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
  List<dynamic> _weeklyForecast = [];

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<String> get citySuggestions => _citySuggestions;
  List<dynamic> get weeklyForecast => _weeklyForecast;

  Future<void> fetchWeatherByCity(String cityName, String unit) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      _weather = await _weatherService.fetchWeather(cityName, unit);
      if (_weather != null) {
        await fetchWeeklyForecast(_weather!.latitude, _weather!.longitude, unit);
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation(String unit) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      Position position = await _locationService.getCurrentLocation();
      _weather = await _weatherService.fetchWeatherByLocation(position.latitude, position.longitude, unit);
      if (_weather != null) {
        await fetchWeeklyForecast(_weather!.latitude, _weather!.longitude, unit);
      }
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
      _citySuggestions = await _weatherService.fetchCitySuggestions(query);
    }

    notifyListeners();
  }

  Future<void> fetchWeeklyForecast(double lat, double lon, String unit) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      _weeklyForecast = await _weatherService.fetchWeeklyForecast(lat, lon, unit);
    } catch (e) {
      _weeklyForecast = [];
      _errorMessage = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
