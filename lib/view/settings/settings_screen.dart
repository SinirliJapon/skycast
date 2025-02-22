import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skycast/core/utils.dart';
import 'package:skycast/providers/theme_provider.dart';
import 'package:skycast/providers/weather_units_provider.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode';
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            title: Text(themeMode),
            subtitle: Text("App Theme"),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
          WeatherUnitSelectionTile(),
        ],
      ),
    );
  }
}

class WeatherUnitSelectionTile extends StatelessWidget {
  const WeatherUnitSelectionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherUnitsProvider = Provider.of<WeatherUnitsProvider>(context);

    return ListTile(
      title: Text(Utils.capitalizeFirstLetter(weatherUnitsProvider.unit)),
      subtitle: Text("Weather Unit"),
      trailing: DropdownButton<double>(
        underline: SizedBox(),
        value: weatherUnitsProvider.unitIndex,
        onChanged: (double? newValue) {
          if (newValue != null) {
            weatherUnitsProvider.setUnit(newValue);
          }
        },
        items: [
          DropdownMenuItem(value: 0, child: Text('Metric (Celsius)', style: TextStyle(fontSize: 16))),
          DropdownMenuItem(value: 1, child: Text('Imperial (Fahrenheit)', style: TextStyle(fontSize: 16))),
          DropdownMenuItem(value: 2, child: Text('Standard (Kelvin)', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}