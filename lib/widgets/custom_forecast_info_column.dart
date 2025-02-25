import 'package:flutter/material.dart';
import 'package:skycast/core/utils.dart';
import 'package:skycast/models/weather_model.dart';
import 'package:skycast/widgets/custom_list_tile.dart';

class CustomForecastInfoColumn extends StatelessWidget {
  const CustomForecastInfoColumn({super.key, required this.weather, required this.unit});
  final WeatherModel weather;
  final String unit;

  @override
  Widget build(BuildContext context) {
    String temperatureUnit = Utils.getUnitSymbol(unit);
    String windSpeedUnit = Utils.getWindSpeedUnit(unit);
    final temperature = weather.temperature.round();
    final feelsLike = weather.feelsLike.round();
    final tempMin = weather.tempMin.round();
    final tempMax = weather.tempMax.round();
    return Column(
      children: [
        CustomListTile(title: "Temperature", icon: Icons.device_thermostat, value: "$temperature$temperatureUnit"),
        CustomListTile(title: "Feels Like", icon: Icons.thermostat, value: "$feelsLike$temperatureUnit"),
        CustomListTile(title: "Min Temperature", icon: Icons.thermostat, value: "$tempMin$temperatureUnit"),
        CustomListTile(title: "Max Temperature", icon: Icons.thermostat, value: "$tempMax$temperatureUnit"),
        CustomListTile(title: "Wind Speed", icon: Icons.wind_power, value: "${weather.windSpeed} $windSpeedUnit"),
        CustomListTile(title: "Humidity", icon: Icons.water_drop, value: "${weather.humidity}%"),
        CustomListTile(title: "Pressure", icon: Icons.air, value: "${weather.pressure} hPa"),
        CustomListTile(title: "Cloudiness", icon: Icons.cloud, value: "${weather.cloudiness}%"),
      ],
    );
  }
}