import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherUnitsProvider with ChangeNotifier {
  double _unitIndex = 0;

  double get unitIndex => _unitIndex;
  String get unit => _getUnitFromIndex(_unitIndex);

  WeatherUnitsProvider() {
    _loadUnit();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    _unitIndex = prefs.getDouble('weather_unit_index') ?? 0;
    notifyListeners();
  }

  Future<void> setUnit(double index) async {
    _unitIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weather_unit_index', index);
    notifyListeners();
  }

  String _getUnitFromIndex(double index) {
    if (index == 1) return "imperial";
    if (index == 2) return "standard";
    return "metric";
  }
}
